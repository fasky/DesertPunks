extends Line2D


# Declare member variables here. Examples:
#tire trail
var t
var p
export var trailLength = 0
export(NodePath) var targetPath
var drawTrail = true

# Called when the node enters the scene tree for the first time.
func _ready():
	t = get_node(targetPath)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = Vector2(0,0)
	global_rotation = 0
	p = t.global_position
	add_point(p)
	while get_point_count() > trailLength:
		remove_point(0)
