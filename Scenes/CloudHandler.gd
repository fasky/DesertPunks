extends Node2D

var clouds = []
var dust = []
var countdown = 90
var countdownDust = 150
var countdownMax = 90
var countdownMaxDust = 150
var cloudObjs = preload("res://Scenes/Cloud.tscn")
var dustObjs = preload("res://Scenes/Dust.tscn")
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for cloud in clouds:
		cloud.position += Vector2(10,10)
		cloud.modulate.a -= .0002
		if(cloud.modulate.a <= 0):
			clouds.erase(cloud)
			cloud.queue_free()
	for dus in dust:
		dus.position += Vector2(10,1)
		dus.rotation_degrees += 4
		dus.modulate.a -= .0003
		if(dus.modulate.a <= 0):
			dust.erase(dus)
			dus.queue_free()
	countdown -= 1
	countdownDust -= 1
	if(countdown < 1):
		rng.randomize()
		var x = rng.randf_range(-2000,300)
		rng.randomize()
		var s = rng.randf_range(0.9,3.0)
		var b = cloudObjs.instance()
		b.scale = Vector2(s,s)
		b.position = Vector2(global_position.x + x, global_position.y - 1500)
		get_node("/root/Rooter").add_child(b)
		clouds.append(b)
		countdown = countdownMax
	if(countdownDust < 1):
		rng.randomize()
		var y = rng.randf_range(0,0)
		rng.randomize()
		var s = rng.randf_range(1.5,4.0)
		var b = dustObjs.instance()
		b.scale = Vector2(s,s)
		b.position = Vector2(global_position.x - 1500, global_position.y + y)
		get_node("/root/Rooter").add_child(b)
		dust.append(b)
		countdownDust = countdownMaxDust
