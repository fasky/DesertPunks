extends KinematicBody2D

#currency
var scrap = 0
onready var particleEmitters = [$SmokeLarge, $SmokeLarge/SmokeLarge2, $SmokeLarge/SmokeLargeEngine, $SmokeSmall, $SmokeSmall/SmokeSmall2, $SmokeSmall/SmokeSmallEngine]

onready var death_sound = preload("res://Scenes/PlayerDeathSound.tscn")
onready var chromaticEffect = preload("res://Scenes/ChromaticEffect.tscn")
onready var bwDeathEffect = preload("res://Scenes/BlurBWDeath.tscn")
onready var explosionScene = preload("res://Scenes/Explosion.tscn")
onready var ramSparks = preload("res://Scenes/BumpSparks.tscn")

var collidingWithEnemy = false
var collidingEnemy = []

# movement
var velocity = Vector2.ZERO
var acceleration = Vector2.ZERO
var steer_direction
var steering_angle = 10
var wheel_base = 50
var engine_power = 450
var canMove = true
var turnSpeed
var baseTurnSpeed = 325
var vehicleType
var friction = -0.2
var drag = -0.001
var braking = -350
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 0.4
var traction_fast_base = 0.4
var traction_slow = 0.8
var mass = 100
var boostAmount = 1000.0
var chainAttackCooldown = 2500
var chainAttackCounter = 2500
var slowTimeCounter = 1000
var slowTimeCooldown = 1000

#misc upgrades
var boost = false
var canBoost = true
var rammingBonus = false
var doubleHealth = false
var doubleArmor = false
var chainAttack = false
var canChain = true
var slowTime = false
var canSlowTime = true

# camera
var cameraZoom = 1.0

# weapons
var fired = false
var autoFired = false
var main_gun_level = 0
var auto_gun_level = 0
var placeable_level = -1
var placeable_cooldown = 200
var placeable_counter = 200
var canFirePlaceable = true
var canFire = true
export(PackedScene) var bulletPlasma
export(PackedScene) var muzzleflash
export(PackedScene) var mine
var mainCooldown = 20
var autoCooldown = 20
var counter = 0
var autoCounter = 0
export var scatterBombPos = []

var dying = false
var explosionPlaying = false
var deathTimer = 220

#defenses
var health = 100
var healthMax = 100
var armor = 0
var armorMax = 100

var smallVeh = false
var largeVeh = false

var scrollFactor = 1.0
# Called when the node enters the scene tree for the first time.
func _ready():
	applyCarVars()

func _process(_delta):
	if(fired):
		counter += 1
		if(counter >= mainCooldown):
			fired = false
			counter = mainCooldown
	if(!canFirePlaceable):
		placeable_counter += 1
		if(placeable_counter >= placeable_cooldown):
			canFirePlaceable = true
			placeable_counter = placeable_cooldown
	if(canChain == false):
		chainAttackCounter += 1
		if(chainAttackCounter >= chainAttackCooldown):
			canChain = true
			chainAttackCounter = chainAttackCooldown
	autoShoot()
	get_node("../CanvasLayer/ScrapLabel").text = " " + str(scrap)
	if(dying):
		$Vehicle.modulate = "515151"
		$MainGun.modulate = "515151"
		$AutoGun.modulate = "515151"
		for x in particleEmitters:
			x.process_material.set("color","830606")
		if(!explosionPlaying):
			add_child(explosionScene.instance())
			explosionPlaying = true
		deathTimer -= 1
		if(deathTimer < 1):
			get_tree().reload_current_scene()

func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction()
	calculate_steering(delta)
	velocity += acceleration * delta
#	if(collidingWithEnemy):
#		for enemy in collidingEnemy:
#			var enemyVel = enemy.velocity
#			var enemyMass = enemy.mass
#			var finForce = enemyMass * enemyVel
#			enemy.applyForce(finForce)
	move_and_slide(velocity)
	cameraZoom = ((velocity.length()/5)+50)/100
	get_node("../Camera2D").zoom = Vector2(cameraZoom * scrollFactor,cameraZoom * scrollFactor)

func _input(event):
	if Input.is_action_pressed("zoomIn"):
		scrollFactor -= .03
		if(scrollFactor < .5):
			scrollFactor = .5
	if Input.is_action_pressed("zoomOut"):
		scrollFactor += .03
		if(scrollFactor > 1.5):
			scrollFactor = 1.5
		
func get_input():
	if(canMove  && !dying):
		var turn = 0
		if Input.is_action_pressed("ui_right"):
			for x in particleEmitters:
				if(x.name == "SmokeSmallEngine" || x.name == "SmokeLargeEngine"):
					x.process_material.set("tangential_accel",75)
				else:
					x.process_material.set("tangential_accel",-75)
			turn += 1
		elif Input.is_action_pressed("ui_left"):
			for x in particleEmitters:
				if(x.name == "SmokeSmallEngine" || x.name == "SmokeLargeEngine"):
					x.process_material.set("tangential_accel",-75)
				else:
					x.process_material.set("tangential_accel",75)
			turn -= 1
		else:
			for x in particleEmitters:
				x.process_material.set("tangential_accel",0)
		turnSpeed = baseTurnSpeed
		if(velocity.length() > 0):
			turnSpeed = turnSpeed/velocity.length()
			if(turnSpeed < 1.0):
				turnSpeed = 1.0
		steer_direction = turn * deg2rad(steering_angle * turnSpeed)
		if(Input.is_action_pressed("ui_up")):
			acceleration = transform.x * engine_power
		if(Input.is_action_pressed("ui_down")):
			acceleration = transform.x * braking
		if(Input.is_action_pressed("boost") && boost && canBoost):
			acceleration *= 2
			boostAmount -= 1
			if(boostAmount < 0):
				canBoost = false
		if(boostAmount < 1000):
			boostAmount += .2
			if(boostAmount > 500):
				canBoost = true
		if(Input.is_action_pressed("slowTime") && slowTime && canSlowTime):
			Engine.time_scale = 0.5
			slowTimeCounter -= 1
			if(slowTimeCounter < 0):
				canSlowTime = false
		else:
			Engine.time_scale = 1.0
		if(slowTimeCounter < 1000):
			slowTimeCounter += .2
			if(slowTimeCounter > 500):
				canSlowTime = true
		if(Input.is_action_pressed("handbrake")):
			traction_fast = .01
		else:
			traction_fast = traction_fast_base
	if(canFire && !dying):
		if(Input.is_action_pressed("fire")):
			if(fired == false):
				shoot()
				fired = true
	if(placeable_level != -1 && canFirePlaceable  && !dying):
		if(Input.is_action_pressed("fireSecondary")):
			secondaryFire()
			placeable_counter = 0
			canFirePlaceable = false
	
func secondaryFire():
	if(placeable_level == 0):
		var b = mine.instance()
		b.nails = true
		owner.add_child(b)
		b.transform = self.global_transform
	elif(placeable_level == 1):
		var b = mine.instance()
		b.mine = true
		owner.add_child(b)
		b.transform = self.global_transform
	elif(placeable_level == 2):
		var b = mine.instance()
		b.bomb = true
		b.targetPosBomb = get_global_mouse_position()
		owner.add_child(b)
		b.transform = self.global_transform
	elif(placeable_level == 3):
		var b = mine.instance()
		b.megaBomb = true
		b.targetPosBomb = get_global_mouse_position()
		owner.add_child(b)
		b.transform = self.global_transform
	elif(placeable_level == 4):
		for scatPoint in scatterBombPos:
			var b = mine.instance()
			b.scatteredBombs = true
			b.speed = 650
			b.targetPosBomb = get_node(scatPoint).global_position
			owner.add_child(b)
			b.transform = self.global_transform
		
	elif(placeable_level == 5):
		var b = mine.instance()
		b.blackHole = true
		b.targetPosBomb = get_global_mouse_position()
		owner.add_child(b)
		b.transform = self.global_transform
	
func autoShoot():
	autoCounter += 1
	if(autoCounter >= autoCooldown):
		autoFired = false
		autoCounter = 0
	if(autoFired == false && auto_gun_level > 0 && $AutoGun.nearbyEnemies.size() > 0):
		var b = bulletPlasma.instance()
		if(auto_gun_level == 1):
			b.init(1300, 30)
			autoCooldown = 12
		elif(auto_gun_level == 2):
			b.init(1800, 100)
			autoCooldown = 16
		elif(auto_gun_level == 3):
			b.init(1800, 65)
			autoCooldown = 8
		elif(auto_gun_level == 4):
			b.init(2000, 150)
			autoCooldown = 12
		elif(auto_gun_level == 5):
			b.init(2000, 75)
			autoCooldown = 5
		owner.add_child(b)
		b.playerVelocity = velocity
		$AutoGun._update_target()
		b.transform = $AutoGun.global_transform
		autoFired = true
	
func shoot():
	var b = bulletPlasma.instance()
	if(main_gun_level == 0):
		b.init()
		mainCooldown = 15
	elif(main_gun_level == 1):
		b.init(1300, 30)
		mainCooldown = 3
	elif(main_gun_level == 2):
		b.init(1800, 100)
		mainCooldown = 6
	elif(main_gun_level == 3):
		b.init(1800, 65)
		mainCooldown = 3
	elif(main_gun_level == 4):
		b.init(2000, 150)
		mainCooldown = 6
	elif(main_gun_level == 5):
		b.init(2000, 75)
		mainCooldown = 2
	else:
		b.init()
		mainCooldown = 20
	owner.add_child(b)
	counter = 0
	if(Input.is_action_pressed("chainAttack") && chainAttack && canChain):
		b.chainAttack = true
		b.changeSprite("Chain")
		canChain = false
		chainAttackCounter = 0
	b.playerVelocity = velocity/2
	b.transform = $MainGun.global_transform
	var c = muzzleflash.instance()
	$MainGun.add_child(c)
	
func damage(damage):
	if(armor <= 0):		
		health -= damage
		if(health <= healthMax/1.5):
			if(smallVeh):
				$SmokeSmall/SmokeSmallEngine.emitting = true
				if(health <= healthMax/3):
					$SmokeSmall/SmokeSmallEngine.process_material.set("color","1c1c1c")
					$SmokeSmall.process_material.set("color","1c1c1c")
					$SmokeSmall/SmokeSmall2.process_material.set("color","1c1c1c")
				else:
					$SmokeSmall/SmokeSmallEngine.process_material.set("color","848484")
					$SmokeSmall.process_material.set("color","848484")
					$SmokeSmall/SmokeSmall2.process_material.set("color","848484")
			elif(largeVeh):
				$SmokeLarge/SmokeLargeEngine.emitting = true
				if(health <= healthMax/3):
					$SmokeLarge/SmokeLargeEngine.process_material.set("color","1c1c1c")
					$SmokeLarge.process_material.set("color","1c1c1c")
					$SmokeLarge/SmokeLarge2.process_material.set("color","1c1c1c")
				else:
					$SmokeLarge/SmokeLargeEngine.process_material.set("color","848484")
					$SmokeLarge.process_material.set("color","848484")
					$SmokeLarge/SmokeLarge2.process_material.set("color","848484")
	else:
		armor -= damage
		if(armor < 0):
			armor = 0
	if(health < 0 && !dying):
		get_node("/root/Rooter/CanvasLayer").add_child(chromaticEffect.instance())
		get_node("/root/Rooter/CanvasLayer").add_child(bwDeathEffect.instance())
		get_node("/root/Globals/PlayerDeathSound").playing = true
		get_node("/root/Rooter/CanvasLayer/Health").visible = false
		get_node("/root/Rooter/CanvasLayer/BoostIndicator").visible = false
		get_node("/root/Rooter/CanvasLayer/ChainAttack").visible = false
		get_node("/root/Rooter/CanvasLayer/SlowIndicator").visible = false
		get_node("/root/Rooter/CanvasLayer/IndicatorBG").visible = false
		get_node("/root/Rooter/CanvasLayer/Placeable").visible = false
		get_node("/root/Rooter/CanvasLayer/Armor").visible = false
		get_node("/root/Rooter/CanvasLayer/ScrapLabel").visible = false
		get_node("/root/Rooter/CanvasLayer/Frame").visible = false
		get_node("/root/Rooter/CanvasLayer/FrameTop").visible = false
		get_node("/root/Rooter/CanvasLayer/MainGunIndicator").visible = false
		PlayerVariables.scrap = scrap
		var saver = Player.new()
		saver.scrap = PlayerVariables.scrap
		saver.boughtUpgrades = PlayerVariables.boughtUpgrades
		saver.vehicleType = PlayerVariables.vehicleType
		saver.healthMult = PlayerVariables.healthMult
		saver.armorMult = PlayerVariables.armorMult
		saver.main_gun_level = PlayerVariables.main_gun_level
		saver.auto_gun_level = PlayerVariables.auto_gun_level
		saver.placeable_level = PlayerVariables.placeable_level
		saver.miscUpgrades = PlayerVariables.miscUpgrades
		saver.player_name = PlayerVariables.playerName
		saver.write_save(PlayerVariables.saveSlotPath)
		dying = true

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = (front_wheel - rear_wheel).normalized()
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = velocity.linear_interpolate(new_heading * velocity.length(), traction)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
func apply_friction():
	if velocity.length() < 5:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force

func applyCarVars():
	var playerVars = get_node("/root/PlayerVariables")
	vehicleType = playerVars.vehicleType
	var vehDict
	get_node("ColliderVehSmall").set_deferred("disabled",true)
	get_node("Collide01/Collide01").set_deferred("disabled",true)
	get_node("ColliderVehLarge").set_deferred("disabled",true)
	get_node("Collide2345/Collide2345").set_deferred("disabled",true)
	smallVeh = false
	largeVeh = false
	$SmokeLarge.emitting = false
	$SmokeLarge/SmokeLarge2.emitting = false
	$SmokeSmall.emitting = false
	$SmokeSmall/SmokeSmall2.emitting = false
	$SmokeLarge/SmokeLargeEngine.emitting = false
	$SmokeSmall/SmokeSmallEngine.emitting = false
	#base vehicle stats
	if(vehicleType == 0):
		vehDict = playerVars.vehicle0Stats
		get_node("ColliderVehSmall").set_deferred("disabled",false)
		get_node("Collide01/Collide01").set_deferred("disabled",false)
		$Vehicle.texture = load("res://Sprites/Veh0.png")
		$SmokeSmall.emitting = true
		$SmokeSmall/SmokeSmall2.emitting = true
		smallVeh = true
	elif(vehicleType == 1):
		vehDict = playerVars.vehicle1Stats
		$Vehicle.texture = load("res://Sprites/Veh1.png")
		get_node("ColliderVehSmall").set_deferred("disabled",false)
		get_node("Collide01/Collide01").set_deferred("disabled",false)
		$SmokeSmall.emitting = true
		$SmokeSmall/SmokeSmall2.emitting = true
		smallVeh = true
	elif(vehicleType == 2):
		$Vehicle.texture = load("res://Sprites/BusBase.png")
		vehDict = playerVars.vehicle2Stats
		get_node("ColliderVehLarge").set_deferred("disabled",false)
		get_node("Collide2345/Collide2345").set_deferred("disabled",false)
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
		largeVeh = true
	elif(vehicleType == 3):
		$Vehicle.texture = load("res://Sprites/ArmoredBus.png")
		vehDict = playerVars.vehicle3Stats
		get_node("ColliderVehLarge").set_deferred("disabled",false)
		get_node("Collide2345/Collide2345").set_deferred("disabled",false)
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
		largeVeh = true
	elif(vehicleType == 4):
		$Vehicle.texture = load("res://Sprites/TankerBaseYR.png")
		vehDict = playerVars.vehicle4Stats
		get_node("ColliderVehLarge").set_deferred("disabled",false)
		get_node("Collide2345/Collide2345").set_deferred("disabled",false)
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
		largeVeh = true
	elif(vehicleType == 5):
		$Vehicle.texture = load("res://Sprites/Veh5.png")
		vehDict = playerVars.vehicle5Stats
		get_node("ColliderVehLarge").set_deferred("disabled",false)
		get_node("Collide2345/Collide2345").set_deferred("disabled",false)
		$SmokeLarge.emitting = true
		$SmokeLarge/SmokeLarge2.emitting = true
		largeVeh = true
		
	health = (vehDict["health"] * playerVars.healthMultActual[playerVars.healthMult])
	armor = (vehDict["armor"] * playerVars.armorMultActual[playerVars.armorMult])
	
	steering_angle = vehDict["steeringAngle"]
	wheel_base = vehDict["wheelBase"]
	engine_power = vehDict["enginePower"]
	baseTurnSpeed = vehDict["baseTurnSpeed"]
	friction = vehDict["friction"]
	drag = vehDict["drag"]
	braking = vehDict["braking"]
	max_speed_reverse = vehDict["maxSpeedReverse"]
	slip_speed = vehDict["slipSpeed"]
	traction_fast_base = vehDict["tractionFastBase"]
	traction_slow = vehDict["tractionSlow"]
	mass = vehDict["mass"]
	
	main_gun_level = playerVars.main_gun_level
	
	auto_gun_level = playerVars.auto_gun_level
	
	if(auto_gun_level < 1):
		$AutoGun.visible = false
	else:
		$AutoGun.visible = true
	
	placeable_level = playerVars.placeable_level
	
	boost = playerVars.miscUpgrades[0]
	rammingBonus = playerVars.miscUpgrades[1]
	doubleHealth = playerVars.miscUpgrades[2]
	doubleArmor = playerVars.miscUpgrades[3]
	chainAttack = playerVars.miscUpgrades[4]
	slowTime = playerVars.miscUpgrades[5]
	
	if(doubleArmor):
		armor *= 2
	
	if(doubleHealth):
		health *= 2
	
	healthMax = health
	armorMax = armor


#func _on_Collide01_area_entered(area):
#	ram(area)
##		collidingWithEnemy = true
##		collidingEnemy.append(area.owner)


#func _on_Collide2345_area_entered(area):
#	ram(area)
##		collidingWithEnemy = true
##		collidingEnemy.append(area.owner)

func ram(area):
	if(area.is_in_group("Enemy") && !area.dying):
		if(!area.rammed && rammingBonus && ((mass > area.mass) || (Input.is_action_pressed("handbrake")))):
			area.damage(1000)
			area.rammed = true
		else:
			if(!area.rammed):
#			&& velocity.length() > 300):
				if(Input.is_action_pressed("handbrake")):
					area.damage(mass/(1500/(velocity.length() + (area.mass/10))))
					damage(area.mass/5)
					area.rammed = true
				else:
					area.damage(mass/(2200/(velocity.length() + (area.mass/10))))
					damage(area.mass/5)
					area.rammed = true


func _on_Collide2345_body_shape_entered(body_id, body, body_shape, area_shape):
	ram(body)
	var body_shape_owner_id = body.shape_find_owner(body_shape)
	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform

	var area_shape_owner_id = shape_find_owner(area_shape)
	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform

	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform, body_shape_2d, body_global_transform)
	if(collision_points.size() > 0 && body_shape_owner.is_in_group("Enemy") && !dying):
		var sparks = ramSparks.instance()
		sparks.global_position = collision_points[0]
#		if(body_shape_owner.owner.rammedTimer >= 28):
#			sparks.modulate = "be2c2c"
		get_parent().add_child(sparks)


func _on_Collide01_body_shape_entered(body_id, body, body_shape, area_shape):
	ram(body)
	var body_shape_owner_id = body.shape_find_owner(body_shape)
	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform

	var area_shape_owner_id = shape_find_owner(area_shape)
	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform

	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform, body_shape_2d, body_global_transform)
	if(collision_points.size() > 0 && body_shape_owner.is_in_group("Enemy") && !dying):
		var sparks = ramSparks.instance()
		sparks.global_position = collision_points[0]
#		if(body_shape_owner.owner.rammedTimer >= 28):
#			sparks.modulate = "be2c2c"
		get_parent().add_child(sparks)
