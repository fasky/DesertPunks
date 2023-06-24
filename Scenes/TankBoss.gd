extends KinematicBody2D

var nearbyEnemies = []
var rotationSpeed = 1
var player
var speed = 100
var health = 10000
var scrapValue = 1000
var dying = false
var mass = 500
var rammed = false
var rammedTimer = 30
var rammedTimerMax = 30
var explosionPlaying = false
onready var explosionScene = preload("res://Scenes/Explosion.tscn")
var canShoot = false
var canShootSecondary = false
var deathDirection = Vector2.ZERO
var deathTimer = 120
var rng = RandomNumberGenerator.new()
var rotateDeath
export(PackedScene) var bulletTank
export(PackedScene) var bulletPlasma
export(PackedScene) var enemyBomb
export(PackedScene) var muzzleflash
var shootTimer = 120
var shootSecondaryTimer = 20
var shootTimerMax = 120
var shootSecondaryTimerMax = 20
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Rooter/Player")

func init(isBoss, isMega):
	if(isBoss):
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").max_value = health
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	if(isMega):
		$Sprite.texture = load("res://Sprites/SuperTankBoss.png")
		$MainGun.texture = load("res://Sprites/SuperTankBossGun.png")
		$MegaTankColl.set_deferred("disabled",false)
		$TankColl.set_deferred("disabled",true)
		$SecondaryGun2.visible = true

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction)
	rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(rammed):
		rammedTimer -= 1
		if(rammedTimer < 1):
			rammed = false
			rammedTimer = rammedTimerMax
	
	if (canShoot && !dying):
		var b = bulletTank.instance()
		b.init(2200,100,self)
		get_node("/root/Rooter").add_child(b)
		b.playerVelocity = velocity
		b.enemyBullet = true
		b.transform = $MainGun.global_transform
		canShoot = false
		shootTimer = shootTimerMax
		var c = muzzleflash.instance()
		c.scale = Vector2(10,10)
		c.position.x += 60
		$MainGun.add_child(c)
		
	if (canShootSecondary && !dying):
		var b = bulletPlasma.instance()
		var c
		if($SecondaryGun2.visible):
			c = bulletPlasma.instance()
			c.init(1300,20,self)
			get_node("/root/Rooter").add_child(c)
			c.playerVelocity = velocity
			c.enemyBullet = true
			c.global_transform = $SecondaryGun2.global_transform
		b.init(1300,20,self)
		get_node("/root/Rooter").add_child(b)
		b.playerVelocity = velocity
		b.enemyBullet = true
		b.global_transform = $SecondaryGun.global_transform
		canShootSecondary = false
		shootSecondaryTimer = shootSecondaryTimerMax
			
		
	if(shootTimer > 0):
		shootTimer -= 1
	else:
		canShoot = true
		
	if(shootSecondaryTimer > 0):
		shootSecondaryTimer -= 1
	else:
		canShootSecondary = true

	if(dying):
		$Sprite.material.set_shader_param("sensitivity", ($Sprite.material.get_shader_param("sensitivity") + .0001) * 1.03)
		if($MainGun.visible):
			$MainGun.material.set_shader_param("sensitivity", ($Sprite.material.get_shader_param("sensitivity") + .0001) * 1.03)
		if(!explosionPlaying):
			$Sprite.modulate = "515151"
			$MainGun.modulate = "515151"
			rng.randomize()
			rotateDeath = rng.randf_range(-360.0,360.0)
			rng.randomize()
			add_child(explosionScene.instance())
			get_node("Explosion").rotation_degrees = rng.randf_range(-360.0,360.0)
			rng.randomize()
			var newScale =  rng.randf_range(3.5,8.0)
			get_node("Explosion").scale = Vector2(newScale, newScale)
			explosionPlaying = true
		skidToStop(delta)
		deathTimer -= 1
		if(deathTimer < 1):
			queue_free()

func _physics_process(delta):
	rotateToTarget(player,delta)
	position += transform.x * speed * delta
	move_and_slide(Vector2(0,0))

func skidToStop(delta):
	if(speed > 0):
		speed -= 4
	position += transform.x * speed * delta

func damage(damage):
	health -= damage
	get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	if (health <= 0 && !dying):
		killCount()

func killCount():
	dying = true
	player.health = player.healthMax
	player.armor = player.armorMax
	get_node("/root/Rooter/Player/Spawner").enemiesKilled[7] += 1
	get_node("/root/Rooter/Player/Spawner").enemyCount[7] -= 1
#	get_node("/root/Rooter/Player/Spawner").checkIfNextWave()
	get_node("/root/Rooter/Player").scrap += scrapValue

func _on_Nearby_body_entered(body):
	if(body.is_in_group("Enemy") && body != self):
		nearbyEnemies.append(body)

func _on_Nearby_body_exited(body):
	if(body.is_in_group("Enemy")):
		nearbyEnemies.erase(body)

func chainKill(alreadyList, body):
	var alreadyFucked = alreadyList
	alreadyFucked.append(body)
	if(!dying):
		damage(100)
	for enemy in nearbyEnemies:
		if(alreadyFucked.find(enemy) == -1 && enemy != self):
			enemy.chainKill(alreadyFucked, self)

func _on_Tank_tree_exiting():
	player.collidingEnemy.erase(self)
