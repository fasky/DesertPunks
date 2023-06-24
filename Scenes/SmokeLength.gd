extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var player = get_node("/root/Rooter/Player")
export var smokeLengthVsSpeed = 550
export var originalColor = ""
var t = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	lifetime = 0.1
	process_material.set("color",originalColor)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += 1
	if(t > 60):
		changeLength()
		t = 0

func changeLength():
	if(emitting):
		lifetime = (player.velocity.length()/smokeLengthVsSpeed) + .0001
