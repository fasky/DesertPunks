extends Node2D

var guns = []
var leftGuns = [18,19,20,21,22,23,24,25,26,27,28]
var rightGuns = [6,7,8,9,10,11,12,13,20,21,24]
var topGuns = [8,9,14,15,16,17,18,19,20,24]
var bottomGuns = [0,1,2,3,4,5,6,7,20,21,22,23]
var bottomInRange = false
var topInRange = false
var leftInRange = false
var rightInRange = false
var playerNodeShootHere
var shootTimer = 5
var shootTimerMax = 5
var rng = RandomNumberGenerator.new()
export(PackedScene) var bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	guns = get_children()
	playerNodeShootHere = get_node("/root/Rooter/Player/ShootHere")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(visible && get_parent().canMove):
		shootTimer -= 1
		processGuns(leftGuns, leftInRange)
		processGuns(rightGuns, rightInRange)
		processGuns(topGuns, topInRange)
		processGuns(bottomGuns, bottomInRange)
#		if(leftInRange):
#			for i in leftGuns:
#				guns[i].look_at(playerNodeShootHere.global_position)
#			if(shootTimer < 1):
#				rng.randomize()
#				rng.randi_range(0,leftGuns.count())
#		if(rightInRange):
#			for i in rightGuns:
#				guns[i].look_at(playerNodeShootHere.global_position)
#		if(topInRange):
#			for i in topGuns:
#				guns[i].look_at(playerNodeShootHere.global_position)
#		if(bottomInRange):
#			for i in bottomGuns:
#				guns[i].look_at(playerNodeShootHere.global_position)

func processGuns(array, inRange):
	if(inRange):
		for i in array:
			guns[i].look_at(playerNodeShootHere.global_position)
		if(shootTimer < 1):
			rng.randomize()
			var g = rng.randi_range(0,array.size()-1)
			var b = bullet.instance()
			b.z_index = 31
			b.init(700,5,owner)
			get_node("/root/Rooter").add_child(b)
			b.enemyBullet = true
			b.transform = guns[array[g]].global_transform
			shootTimer = shootTimerMax

func _on_LeftRange_body_entered(body):
	if(body.is_in_group("Player")):
		leftInRange = true

func _on_TopRange_body_entered(body):
	if(body.is_in_group("Player")):
		topInRange = true

func _on_RighRange_body_entered(body):
	if(body.is_in_group("Player")):
		rightInRange = true

func _on_BottomRange_body_entered(body):
	if(body.is_in_group("Player")):
		bottomInRange = true

func _on_LeftRange_body_exited(body):
	if(body.is_in_group("Player")):
		leftInRange = false

func _on_RighRange_body_exited(body):
	if(body.is_in_group("Player")):
		rightInRange = false

func _on_BottomRange_body_exited(body):
	if(body.is_in_group("Player")):
		bottomInRange = false

func _on_TopRange_body_exited(body):
	if(body.is_in_group("Player")):
		topInRange = false
