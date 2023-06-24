extends KinematicBody2D

var nearbyEnemies = []
var rotationSpeed = 3
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
export(PackedScene) var enemyBomb
export(PackedScene) var sparks
var shootTimer = 240
var shootSecondaryTimer = 120
var shootTimerMax = 240
var shootSecondaryTimerMax = 120
var velocity = Vector2.ZERO
var isMegaBoss = false
var canMove = false
var speedModifier = 1.0

var speedChangeTimer = 60
var speedChangeTimerMax = 25
var underground = true
var aboveGroundTimer = 600
var aboveGroundTimerMax = 600
var undergroundTimer = 180
var undergroundTimerMax = 180
var comingUp = false
var comingUpTimer = 60
var comingUpTimerMax = 60
var goingDown = false
var goingDownTimer = 120
var goingDownTimerMax = 120
export var scatterBombPos = []
var disruptCountdown = 45
var disruptCountdownMax = 45

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Rooter/Player")

func init(isBoss, isMega, heal: float = 10000):
	health = heal
	if(isBoss):
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").max_value = health
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	isMegaBoss = isMega
	if(isMega):
		$Worm.frames = load("res://Sprites/MegaWormSpritesheet.tres")

func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction)
	rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!dying):
		if(underground):
			if(comingUp):
				comingUpTimer -= 1
				get_node("../Camera2D").shake_strength = 100.0
				if(comingUpTimer < 1):
					$WormCollider.set_deferred("disabled",false)
					$WormDestroyer/Col.set_deferred("disabled",false)
					disruptCountdown = disruptCountdownMax
					$BurstGround.visible = true
					$BurstGround.play()
					$Worm.visible = true
					$Trail.trailLength = 100
					comingUpTimer = comingUpTimerMax
					comingUp = false
					underground = false
					canMove = true
			else:
				if($GroundDisrupt.visible):
					disruptCountdown -= 1
					if(disruptCountdown < 1):
						$GroundDisrupt.visible = false
				undergroundTimer -= 1
				if(undergroundTimer < 1):
					comingUp = true
					$GroundDisrupt.visible = true
					global_position = player.global_position
					canMove = false
					undergroundTimer = undergroundTimerMax
		else:
			if(goingDown):
				goingDownTimer -=1
				get_node("../Camera2D").shake_strength = 60.0
				if(goingDownTimer < 1):
					$Worm.visible = false
					$Trail.trailLength = 0
					disruptCountdown = disruptCountdownMax
					$WormCollider.set_deferred("disabled",true)
					$WormDestroyer/Col.set_deferred("disabled",true)
					$BurstGround.visible = true
					$BurstGround.play()
					goingDownTimer = goingDownTimerMax
					goingDown = false
					underground = true
			else:
				if($GroundDisrupt.visible):
					disruptCountdown -= 1
					if(disruptCountdown < 1):
						$GroundDisrupt.visible = false
				aboveGroundTimer -= 1
				if(aboveGroundTimer < 1):
					$GroundDisrupt.visible = true
					goingDown = true
					aboveGroundTimer = aboveGroundTimerMax
		if(rammed):
			rammedTimer -= 1
			if(rammedTimer < 1):
				rammed = false
				rammedTimer = rammedTimerMax
			
		if(shootTimer > 0):
			shootTimer -= 1
		else:
			canShoot = true
			
		if(canShoot && canMove):
			for scatPoint in scatterBombPos:
				var b = enemyBomb.instance()
				b.wormAttack = true
				b.speed = 1000
				b.targetPosBomb = get_node(scatPoint).global_position
				get_parent().add_child(b)
				b.transform = self.global_transform
			canShoot = false
			shootTimer = shootTimerMax
			if(isMegaBoss):
				shootTimer = (shootTimerMax-60)

	elif(dying):
		get_node("../Camera2D").shake_strength = 60.0
		deathTimer -= 1
		if(deathTimer == 15):
			$Worm.visible = false
			$BurstGround.visible = true
			$GroundDisrupt.visible = false
			$BurstGround.play()
		if(deathTimer < 1):
			queue_free()

func _physics_process(delta):
	if(canMove):
		speedChangeTimer -= 1
		if(speedChangeTimer < 1):
			rng.randomize()
			speedModifier = rng.randf_range(2.0,8.0)
			speedChangeTimer = speedChangeTimerMax
		rotateToTarget(player,delta)
		position += transform.x * (speed * speedModifier) * delta
		move_and_slide(Vector2(0,0))

func damage(damage):
	health -= damage
	get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	if (health <= 0 && !dying):
		killCount()

func killCount():
	dying = true
	canMove = false
	player.health = player.healthMax
	player.armor = player.armorMax
	get_node("/root/Rooter/Player/Spawner").enemiesKilled[7] += 1
	get_node("/root/Rooter/Player/Spawner").enemyCount[7] -= 1
	get_node("/root/Rooter/Player").scrap += scrapValue
	$BurstGround.visible = true
	$BurstGround.play()
	$BurstGround.modulate = "a70000"
	$Worm.modulate = "a70000"
	$GroundDisrupt.visible = true
	$GroundDisrupt.modulate = "a70000"
#	get_node("/root/Rooter/Player/Spawner").checkIfNextWave()

func _on_WormBoss_tree_exiting():
	player.collidingEnemy.erase(self)


func _on_BurstGround_animation_finished():
	$BurstGround.visible = false


func _on_WormDestroyer_body_entered(body):
	if(body.is_in_group("Enemy") && !body.is_in_group("Worm")):
		body.damage(1000)
