extends Sprite

var nearbyEnemies = []

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _update_target():
	if(nearbyEnemies.size() > 0):
		look_at(nearbyEnemies[0].global_position)
		if(nearbyEnemies[0].dying):
			look_at(nearbyEnemies[nearbyEnemies.size()-1].global_position)

func _on_Area2D_body_entered(body):
	if(body.is_in_group("Enemy")):
		nearbyEnemies.append(body)


func _on_Area2D_body_exited(body):
	if(body.is_in_group("Enemy")):
		nearbyEnemies.erase(body)
