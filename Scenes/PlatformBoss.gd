extends KinematicBody2D

var health = 2000
var maxHealth = 2000
var canMove = true
var mass = 10000
var dying = false
var scrapValue = 1000
var rotationSpeed = .1
var player
var speed = 100
var deathCounter = 360
export(PackedScene) var explosionScene
onready var explosions = $Explosions.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node("/root/Rooter/Player")
	get_node("/root/Rooter/CanvasLayer/Frame/BossBar").max_value = health
	get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
	global_position = player.global_position
	global_position.x = player.global_position.x + 2500

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!dying):
		rotateToTarget(player,delta)
		position += transform.x * (speed) * delta
		move_and_slide(Vector2(0,0))
		if(health < 1):
			$Platform.modulate = "#ffcaca"
			dying = true
			canMove = false
			for x in explosions:
				x.paused = false
	else:
		if(deathCounter > 230):
			$BlindingLight.scale += Vector2(.01,.01)
			$BlindingLight.modulate.a += .001
		elif(deathCounter > 90):
			$BlindingLight.scale += Vector2(.025,.025)
			$BlindingLight.modulate.a += .005
		else:
			$BlindingLight.scale += Vector2(.075,.075)
		deathCounter -= 1
		if(deathCounter < 1):
			$Platform.modulate = "#383838"
			$BlindingLight.modulate.a -= .006
			$BlindingLight.scale -= Vector2(.3,.3)
#			$Platform.visible = false
			$Guns.visible = false
			if(deathCounter < -60):
				var b = explosionScene.instance()
				killCount()
				b.global_position = global_position
				b.scale = Vector2(20,20)
				get_parent().add_child(b)
				queue_free()
	
func rotateToTarget(target, delta):
	var direction = (target.global_position - global_position)
	var angleTo = transform.x.angle_to(direction)
	rotate(sign(angleTo) * min(delta * rotationSpeed, abs(angleTo)))

func killCount():
	player.health = player.healthMax
	player.armor = player.armorMax
	get_node("/root/Rooter/Player/Spawner").enemiesKilled[7] += 1
	get_node("/root/Rooter/Player/Spawner").enemyCount[7] -= 1
	get_node("/root/Rooter/Player").scrap += scrapValue
#	get_node("/root/Rooter/Player/Spawner").checkIfNextWave()

func _on_Top_area_entered(area):
	checkBulletEntered(area)


func _on_Bottom_area_entered(area):
	checkBulletEntered(area)


func _on_Left_area_entered(area):
	checkBulletEntered(area)


func _on_Right_area_entered(area):
	checkBulletEntered(area)

func checkBulletEntered(area):
	if(area.is_in_group("Bullet") && !area.enemyBullet):
		health -= area.damage
		get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = health
