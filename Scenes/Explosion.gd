extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var i = 0
export var timed = false
export var looping = false
export var noDisturbDust = false
export var delay = 0
export var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if(!timed):
		playFX()
		
func _process(delta):
	if(!paused && delay > 0):
		delay -= 1
		if(delay < 1):
			playFX()
	
func playFX():
	get_node("/root/Rooter/Camera2D").shake_strength = 20.0
	frame = 0
	$Explode.play()
	if(!noDisturbDust):
		$Discruption.frame = 0
		$Discruption.play()
	$Light2D.enabled = true
	play()
	


func _on_Explosion_animation_finished():
	if(!looping):
		i += 1
		if(i == 1):
			queue_free()
	else:
		playFX()
