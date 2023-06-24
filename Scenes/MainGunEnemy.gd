extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var closeToPlayer = false
var playerNode
var playerNodeShootHere
export var tank = false
export var aimingTurret = true
export var spinningTurret = false
export var rotationSpeed = 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	playerNode = get_node("/root/Rooter/Player")
	playerNodeShootHere = get_node("/root/Rooter/Player/ShootHere")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(visible):
		if(aimingTurret):
			if(tank):
				look_at(playerNodeShootHere.get_owner().global_position)
			else:
				look_at(playerNodeShootHere.global_position)
	#			if(global_position.distance_to(playerNode.global_position) < 400):
	#				look_at(playerNode.global_position)
	#			else:
	#				look_at(playerNodeShootHere.global_position)
		elif(spinningTurret):
			rotation_degrees += (1 * rotationSpeed)
