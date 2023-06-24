extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var i = 44
var t = 60
var tdown = true
export var wave = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Wave " + str(wave)


func _process(delta):
	if(i > 60):
		queue_free()
		
	if(i > 2):
		rect_position.x += i
		if(tdown):
			i -= 1
		else:
			i += 1
	else:
		if(tdown):
			rect_position.x += i
			t -= 1
			if(t < 1):
				tdown = false
		else:
			i += 1
