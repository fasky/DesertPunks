extends KinematicBody2D

onready var particleEmitters = [$SmokeLarge, $SmokeLarge/SmokeLarge2]

# Declare member variables here. Examples:
var health = 2000
var maxHealth = 2000
onready var target = get_parent().get_node("Player").position
onready var player = get_parent().get_node("Player")
var speed = 400
var velocity = Vector2.ZERO
var radar = 1100
var radarClosest = 250
var canBomb = false
export(PackedScene) var enemyBomb
var bombTimer = 200
var bombTimerMax = 200
var bombMaxRange = 450
var bombMinRange = 250
var enemyType = 0
var scrapValue = 1
var dying = false
var canMove = true
var playerInRange = false
var playerInBombRange = false
var explosionPlaying = false
var rng = RandomNumberGenerator.new()
var mass = 500
var deathTimer = 120
var largeColl
var rammed = false
var rammedTimer = 30
var rammedTimerMax = 30
var deathCamped = false

var rammer = false
var shooter = false
var bomber = false

var rammingDistanceToPlayer = false

var rotationSpeed = 1.0

var playerNodeShootHere

#onready var explosionScene = preload("res://Scenes/Explosion.tscn")
func init(isBoss, isMega):
	shooter = true
	bomber = true
	if(!isMega):
		health = 2000
		maxHealth = health
	else:
		health = 5000
		maxHealth = health
		$TankerGuns/ThirdGun.visible = true
		$TankerGuns.shootTimer = 6
		$TankerGuns.shootTimerMax = 6

	if(isBoss):
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").max_value = health
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
# Called when the node enters the scene tree for the first time.
func _ready():
	playerNodeShootHere = get_node("/root/Rooter/Player/ShootHere")
	init(true,false)

func ramTimer():
	if(rammed):
		rammedTimer -= 1
		if(rammedTimer < 1):
			rammed = false
			rammedTimer = rammedTimerMax

func bombingRangeCheck():
	if(position.distance_to(player.position) > bombMaxRange || position.distance_to(player.position) < bombMinRange):		
		playerInBombRange = false
	else:
		playerInBombRange = true

func bomberFunc():
	bombingRangeCheck()
	if(canBomb && playerInBombRange):
		var b = enemyBomb.instance()
		b.damage = 25
		b.speed = 1000
		b.enemyPlaceable = true
		b.targetPosBomb = playerNodeShootHere.global_position
		get_parent().add_child(b)
		b.transform = self.global_transform
		b.scale = Vector2(3,3)
		canBomb = false
		bombTimer = bombTimerMax
	if(bombTimer > 0):
		bombTimer -= 1
	else:
		canBomb = true

func movingFunc(delta):
	if(!rammer && !rammingDistanceToPlayer):
		rotateToTarget(get_parent().get_node("Player"), delta)
	elif(rammer):
		rotateToTarget(get_parent().get_node("Player"), delta)
	if(rammer && rammingDistanceToPlayer && !rammed):
		position += transform.x * speed * delta * 1.4
	else:
		position += transform.x * speed * delta

func colCheck():
	move_and_slide(Vector2(0,0))

func dissolver():
	modulate.a -= .01
#	$Sprite.material.set_shader_param("sensitivity", ($Sprite.material.get_shader_param("sensitivity") + .001) * 1.03)
#	if($MainGun.visible):
#		$MainGun.material.set_shader_param("sensitivity", ($Sprite.material.get_shader_param("sensitivity") + .001) * 1.03)

func startExplosion():
	$SmokeLarge.emitting = false
	$SmokeLarge/SmokeLarge2.emitting = false
	$Sprite.modulate = "515151"
	$TankerGuns/MainGun.modulate = "515151"
	$TankerGuns/SecondGun.modulate = "515151"
	$TankerGuns/ThirdGun.modulate = "515151"
	rng.randomize()
	get_node("Explosion").rotation_degrees = rng.randf_range(-360.0,360.0)
	get_node("Explosion").playFX()
	explosionPlaying = true
	
func deathTimerFunc():
	deathTimer -= 1
	if(deathTimer < 1):
#		queue_free()
		get_node("/root/Rooter/DeathCamp").killQueue.append(self)
		deathCamped = true
	
func _process(delta):
	if(!dying):
		ramTimer()
#		radarCheck()
#		if(shooter):
#			shooterFunc()
		if(bomber):
			bomberFunc()
		if(canMove):
			movingFunc(delta)
			colCheck()
	else:
		dissolver()
		if(!explosionPlaying):
			startExplosion()
		skidToStop(delta)
		if(!deathCamped):
			deathTimerFunc()


func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction)
	rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))

func damage(damage):
	health -= damage
	get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	if(health < maxHealth/2):
		for x in particleEmitters:
			x.process_material.set("color","1c1c1c")
	if (health <= 0 && !dying):
		killCount()

func skidToStop(delta):
	if(speed > 0):
		speed -= 4
	position += transform.x * speed * delta
	
var nearbyEnemies = []

func _on_Nearby_body_entered(body):
	if(body.is_in_group("Enemy") && body != self):
		nearbyEnemies.append(body)
	elif(body.is_in_group("Friendly") || body.is_in_group("Player")):
		rammingDistanceToPlayer = true
		
func _on_Nearby_body_exited(body):
	if(body.is_in_group("Enemy")):
		nearbyEnemies.erase(body)
	elif(body.is_in_group("Friendly") || body.is_in_group("Player")):
		rammingDistanceToPlayer = false

func chainKill(alreadyList, body):
	var alreadyFucked = alreadyList
	alreadyFucked.append(body)
	damage(100)
	for enemy in nearbyEnemies:
		if(alreadyFucked.find(enemy) == -1 && enemy != self):
			enemy.chainKill(alreadyFucked, self)

func killCount():
	dying = true
	if(get_node("/root/Rooter/Player/Spawner").enemyCount[7] == 1):
		player.health = player.healthMax
		player.armor = player.armorMax
	get_node("/root/Rooter/Player/Spawner").enemiesKilled[7] += 1
	get_node("/root/Rooter/Player/Spawner").enemyCount[7] -= 1
#	get_node("/root/Rooter/Player/Spawner").checkIfNextWave()
	get_node("/root/Rooter/Player").scrap += scrapValue


func _on_SuperTanker_tree_exiting():
	player.collidingEnemy.erase(self)
