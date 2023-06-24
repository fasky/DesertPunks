extends Light2D

var i = 20

func _process(delta):
	if(enabled):
		i -= 1
		if(i < 1):
			if(get_parent().looping):
				enabled = false
				i = 20
			else:
				queue_free()
	
