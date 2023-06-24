extends Node2D


# Declare member variables here. Examples:
var rng = RandomNumberGenerator.new()
export var sprites = []
var spawn = true
var spawnTimer = 40
var spawnTimerMax = 40
onready var ranSpriteScene = load("res://Scenes/RandomSpriteMenuScroll.tscn")
var move = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(move):
		$Sand1.position.y += 5
		$Sand2.position.y += 5
		if($Sand1.position.y > 1472):
			$Sand1.position.y = -1460
		if($Sand2.position.y > 1472):
			$Sand2.position.y = -1460
		if(spawn):
			rng.randomize()
			var my_random_number = rng.randi_range(0, sprites.size()-1)
			var ranSprite = sprites[my_random_number]
			var b = ranSpriteScene.instance()
			rng.randomize()
			b.position.y = -120
			b.position.x = rng.randf_range(0,1400)
			rng.randomize()
			b.rotation_degrees = rng.randf_range(120,60)
			b.texture = load(ranSprite)
			add_child(b)
			spawn = false
		else:
			spawnTimer -= 1
			if(spawnTimer < 1):
				spawnTimer = spawnTimerMax
				spawn = true
