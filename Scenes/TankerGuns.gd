extends Node2D

var guns = []
var playerNodeShootHere
var shootTimer = 10
var shootTimerMax = 10
var rng = RandomNumberGenerator.new()
export(PackedScene) var bullet

# Called when the node enters the scene tree for the first time.
func _ready():
	guns = get_children()
	for x in guns:
		if x.visible == false:
			guns.erase(x)
	playerNodeShootHere = get_node("/root/Rooter/Player/ShootHere")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(visible && !get_parent().dying):
		shootTimer -= 1
		processGuns()

func processGuns():
	for i in guns:
		i.look_at(playerNodeShootHere.global_position)
	if(shootTimer < 1):
		rng.randomize()
		var g = rng.randi_range(0,guns.size()-1)
		var b = bullet.instance()
		b.z_index = 31
		b.init(700,5,owner)
		get_node("/root/Rooter").add_child(b)
		b.enemyBullet = true
		b.transform = guns[g].global_transform
		shootTimer = shootTimerMax
