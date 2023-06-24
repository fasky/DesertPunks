extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Player.new()
	if((player.save_exists("./slot1.tres"))):
		var b = player.load_game("./slot1.tres")
		get_node("VBoxContainer/Slot1").hint_tooltip = b.player_name
	if((player.save_exists("./slot2.tres"))):
		var b = player.load_game("./slot2.tres")
		get_node("VBoxContainer/Slot2").hint_tooltip = b.player_name
	if((player.save_exists("./slot3.tres"))):
		var b = player.load_game("./slot3.tres")
		get_node("VBoxContainer/Slot3").hint_tooltip = b.player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")

func newVals(slotPath):
	var player = Player.new()
	player.player_name = get_node("VBoxContainer/NameEnter").text
	player.write_save(slotPath)
	get_node("/root/PlayerVariables").saveSlotPath = slotPath
	get_node("/root/PlayerVariables").resetVals()
	get_node("/root/Globals/AudioStreamPlayer").playing = false
	get_node("/root/Globals/ScrollingBG").move = false
	get_tree().change_scene("res://Scenes/MainMap.tscn")

func _on_Slot1_pressed():
	newVals("./slot1.tres")

func _on_Slot2_pressed():
	newVals("./slot2.tres")

func _on_Slot3_pressed():
	newVals("./slot3.tres")


func _on_Slot1_mouse_entered():
	var player = Player.new()
	if((player.save_exists("./slot1.tres"))):
		var b = player.load_game("./slot1.tres")
		get_node("VBoxContainer/Slot1").text = "Overwrite?"


func _on_Slot2_mouse_entered():
	var player = Player.new()
	if((player.save_exists("./slot2.tres"))):
		var b = player.load_game("./slot2.tres")
		get_node("VBoxContainer/Slot2").text = "Overwrite?"


func _on_Slot3_mouse_entered():
	var player = Player.new()
	if((player.save_exists("./slot3.tres"))):
		var b = player.load_game("./slot3.tres")
		get_node("VBoxContainer/Slot3").text = "Overwrite?"


func _on_Slot1_mouse_exited():
	get_node("VBoxContainer/Slot1").text = "- Slot 1 -"


func _on_Slot2_mouse_exited():
	get_node("VBoxContainer/Slot2").text = "- Slot 2 -"


func _on_Slot3_mouse_exited():
	get_node("VBoxContainer/Slot3").text = "- Slot 3 -"
