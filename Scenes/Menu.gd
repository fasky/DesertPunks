extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	get_node("/root/Globals/ScrollingBG").move = true
	
func _on_New_pressed():
	get_tree().change_scene("res://Scenes/NewSelect.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Options_pressed():
	get_tree().change_scene("res://Scenes/Options.tscn")


func _on_Play_pressed():
	get_tree().change_scene("res://Scenes/SaveSelect.tscn")
