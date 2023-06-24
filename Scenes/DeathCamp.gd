extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var killQueue = []
var KillQueueCounter = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if killQueue.size()>0:
		while KillQueueCounter:
			if killQueue.size()>0:
				killQueue[0].queue_free()
				killQueue.remove(0)
				KillQueueCounter-=1
			else:
				KillQueueCounter=0
		KillQueueCounter=1
