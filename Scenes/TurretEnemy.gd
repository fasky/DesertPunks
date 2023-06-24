extends StaticBody2D

export(PackedScene) var bulletPlasma
export var shootTimer = 20
export var shootTimerMax = 20
var canShoot = true
export var health = 200
var dying = false
var mass = 100
var rammed = false
var rammedTimer = 30
var rammedTimerMax = 30
export var radar = 1000
onready var player = get_parent().get_node("Player")
var playerInRange = false
var deathCamped = false
var explosionPlaying = false
var rng = RandomNumberGenerator.new()
var deathTimer = 120
export var spinningCircleTurret = false
export var spinningTurret = false
export var aimingTurret = true
export var rotationSpeed = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainGun.spinningTurret = spinningTurret
	$MainGun.rotationSpeed = rotationSpeed
	$MainGun.aimingTurret = aimingTurret

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!dying):
		ramTimer()
		radarCheck()
		shootTimer -= 1
		if(shootTimer < 1):
			var b = bulletPlasma.instance()
			b.init(800,5,self)
			get_node("/root/Rooter").add_child(b)
			b.enemyBullet = true
			b.transform = $MainGun.global_transform
			shootTimer = shootTimerMax
	else:
		dissolver()
		if(!explosionPlaying):
			startExplosion()
		if(!deathCamped):
			deathTimerFunc()

func startExplosion():
	$MainGun.modulate = "515151"
	rng.randomize()
	get_node("Explosion").rotation_degrees = rng.randf_range(-360.0,360.0)
	rng.randomize()
	var newScale =  rng.randf_range(3.5,8.0)
	get_node("Explosion").scale = Vector2(newScale, newScale)
	get_node("Explosion").playFX()
	explosionPlaying = true
	
func deathTimerFunc():
	deathTimer -= 1
	if(deathTimer < 1):
		get_node("/root/Rooter/DeathCamp").killQueue.append(self)
		deathCamped = true

func dissolver():
	modulate.a -= .01
	
func ramTimer():
	if(rammed):
		rammedTimer -= 1
		if(rammedTimer < 1):
			rammed = false
			rammedTimer = rammedTimerMax

func damage(dam):
	health -= dam
	if(health < 0):
		dying = true
		$Collider.set_deferred("disabled", true)

func radarCheck():
	if(position.distance_to(player.position) > radar):
			playerInRange = false
	else:
		playerInRange = true
