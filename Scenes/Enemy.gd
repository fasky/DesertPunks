extends KinematicBody2D

onready var particleEmitters = [$SmokeLarge, $SmokeLarge/SmokeLarge2, $SmokeSmall, $SmokeSmall/SmokeSmall2]

# Declare member variables here. Examples:
var health = 50
var maxHealth = 50
onready var target = get_parent().get_node("Player").position
onready var player = get_parent().get_node("Player")
var speed = 400
var velocity = Vector2.ZERO
var radar = 1100
var radarClosest = 250
var canShoot = false
var canBomb = false
export(PackedScene) var bulletPlasma
export(PackedScene) var enemyBomb
var shootTimer = 100
var shootTimerMax = 100
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
var mass = 100
var deathTimer = 120
var largeColl
var smallColl
var deathSlideT = 0.0
var deathDirection = Vector2.ZERO
var dyingRotation
#var rotateDeath
var smallForceColl
var largeForceColl
var rammed = false
var rammedTimer = 30
var rammedTimerMax = 30
var deathCamped = false

var rammer = false
var shooter = false
var bomber = false

var rammingDistanceToPlayer = false

var rotationSpeed = 2.0

var playerNodeShootHere

#onready var explosionScene = preload("res://Scenes/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNodeShootHere = get_node("/root/Rooter/Player/ShootHere")

func ramTimer():
	if(rammed):
		rammedTimer -= 1
		if(rammedTimer < 1):
			rammed = false
			rammedTimer = rammedTimerMax

func radarCheck():
	if(position.distance_to(player.position) > radar):
			playerInRange = false
	else:
		playerInRange = true

func shooterFunc():
	if (canShoot && playerInRange):
		var b = bulletPlasma.instance()
		b.init(1000,5,self)
		get_node("/root/Rooter").add_child(b)
		b.playerVelocity = velocity
		b.enemyBullet = true
		b.transform = $MainGun.global_transform
		canShoot = false
		shootTimer = shootTimerMax
		
	if(shootTimer > 0):
		shootTimer -= 1
	else:
		canShoot = true

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
		b.speed = 750
		b.enemyPlaceable = true
		b.targetPosBomb = playerNodeShootHere.global_position
		get_parent().add_child(b)
		b.transform = self.global_transform
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
	$SmokeSmall.emitting = false
	$SmokeSmall/SmokeSmall2.emitting = false
	$Sprite.modulate = "515151"
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
#		queue_free()
		get_node("/root/Rooter/DeathCamp").killQueue.append(self)
		deathCamped = true
	
func _process(delta):
	if(!dying):
		ramTimer()
		radarCheck()
		if(shooter):
			shooterFunc()
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

func init(enemyKind, wave):
	largeColl = get_node("LargeColl")
	smallColl = get_node("SmallColl")
#	smallForceColl = get_node("EnemyForceCollSmall/CollisionShape2D")
#	largeForceColl = get_node("EnemyForceCollLarge/CollisionShape2D")
	if(enemyKind == 0):
		enemyType = enemyKind
		speed = 400
		health = 50
		radar = 1100
		radarClosest = 200
		shootTimerMax = 100
		shootTimer = 100
		scrapValue = 1
		rotationSpeed = 2.5
		$Sprite.texture = load("res://Sprites/veh0.png")
		$MainGun.visible = false
		smallColl.set_deferred("disabled", false)
#		smallForceColl.set_deferred("disabled", false)
		mass = 45
		rammer = true
		$SmokeSmall.emitting = true
		$SmokeSmall/SmokeSmall2.emitting = true
	elif(enemyKind == 1):
		enemyType = enemyKind
		speed = 500
		mass = 75
		health = 100
		radar = 1100
		radarClosest = 200
		shootTimerMax = 50
		shootTimer = 50
		rotationSpeed = 2.0
		scrapValue = 2
		$Sprite.texture = load("res://Sprites/veh0.png")
		smallColl.set_deferred("disabled", false)
#		smallForceColl.set_deferred("disabled", false)
		rammer = true
		shooter = true
		$SmokeSmall.emitting = true
		$SmokeSmall/SmokeSmall2.emitting = true
	elif(enemyKind == 2):
		enemyType = enemyKind
		speed = 350
		health = 150
		radar = 1100
		radarClosest = 200
		shootTimerMax = 25
		shootTimer = 25
		scrapValue = 5
		$Sprite.texture = load("res://Sprites/veh1.png")
		smallColl.set_deferred("disabled", false)
#		smallForceColl.set_deferred("disabled", false)
		mass = 250
		rotationSpeed = 2.0
		rammer = true
		shooter = true
		$SmokeSmall.emitting = true
		$SmokeSmall/SmokeSmall2.emitting = true
	elif(enemyKind == 3):
		enemyType = enemyKind
		speed = 350
		health = 250
		radar = 1100
		radarClosest = 200
		shootTimerMax = 25
		shootTimer = 25
		scrapValue = 5
		$Sprite.texture = load("res://Sprites/BusBase.png")
		largeColl.set_deferred("disabled", false)
#		largeForceColl.set_deferred("disabled", false)
		rotationSpeed = 1.5
		mass = 250
		shooter = true
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
	elif(enemyKind == 4):
		rotationSpeed = 1.5
		enemyType = enemyKind
		speed = 350
		health = 400
		radar = 1100
		radarClosest = 200
		shootTimerMax = 25
		shootTimer = 25
		scrapValue = 5
		$Sprite.texture = load("res://Sprites/ArmorBusBase.png")
		largeColl.set_deferred("disabled", false)
#		largeForceColl.set_deferred("disabled", false)
		mass = 250
		shooter = true
		bomber = true
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
	elif(enemyKind == 5):
		rotationSpeed = 1.5
		enemyType = enemyKind
		speed = 350
		health = 750
		radar = 1100
		radarClosest = 200
		shootTimerMax = 25
		shootTimer = 25
		scrapValue = 5
		$Sprite.texture = load("res://Sprites/TankerBase.png")
		largeColl.set_deferred("disabled", false)
#		largeForceColl.set_deferred("disabled", false)
		mass = 250
		shooter = true
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
	elif(enemyKind == 6):
		rotationSpeed = 1.5
		enemyType = enemyKind
		speed = 350
		health = 1000
		radar = 1100
		radarClosest = 200
		shootTimerMax = 25
		shootTimer = 25
		scrapValue = 5
		$Sprite.texture = load("res://Sprites/ArmoredTankerBase.png")
		largeColl.set_deferred("disabled", false)
#		largeForceColl.set_deferred("disabled", false)
		mass = 250
		shooter = true
		bomber = true
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
	else:
		queue_free()
		
	maxHealth = health

func damage(damage):
	health -= damage
	if(health < maxHealth/2):
		for x in particleEmitters:
			x.process_material.set("color","1c1c1c")
	if (health <= 0 && !dying):
		killCount()
#		queue_free()

func skidToStop(delta):
#	deathSlideT += 0.001
#	rotation_degrees = dyingRotation + ((rotationTarget - dyingRotation) * deathSlideT)
	if(speed > 0):
		speed -= 4
	position += transform.x * speed * delta
#	move_and_slide(Vector2(0,0))
#	velocity = deathDirection * speed
#	move_and_slide(velocity)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
#	if(canMove && !dying):
##		if(!rammer && !rammingDistanceToPlayer):
##			rotateToTarget(get_parent().get_node("Player"), delta)
##		elif(rammer):
##			rotateToTarget(get_parent().get_node("Player"), delta)
##		if(rammer && rammingDistanceToPlayer && !rammed):
##			position += transform.x * speed * delta * 1.5
##		else:
##			position += transform.x * speed * delta
#		move_and_slide(Vector2(0,0))
	
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
	if(!dying):
		killCount()
	for enemy in nearbyEnemies:
		if(alreadyFucked.find(enemy) == -1 && enemy != self):
			enemy.chainKill(alreadyFucked, self)
#	queue_free()

func killCount():
	dying = true
#	deathDirection = position.direction_to(target)
#	dyingRotation = rotation_degrees
	largeColl.set_deferred("disabled", true)
	smallColl.set_deferred("disabled", true)
	get_node("/root/Rooter/Player/Spawner").enemiesKilled[enemyType] += 1
	get_node("/root/Rooter/Player/Spawner").enemyCount[enemyType] -= 1
#	get_node("/root/Rooter/Player/Spawner").checkIfNextWave()
	get_node("/root/Rooter/Player").scrap += scrapValue


func _on_Enemy_tree_exiting():
	player.collidingEnemy.erase(self)
