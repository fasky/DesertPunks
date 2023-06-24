extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var player = Player.new()
	if(!(player.save_exists("./slot1.tres"))):
		get_node("VBoxContainer/Slot1").set_deferred("disabled",true)
	else:
		var b = player.load_game("./slot1.tres")
		get_node("VBoxContainer/Slot1").hint_tooltip = b.player_name
	if(!(player.save_exists("./slot2.tres"))):
		get_node("VBoxContainer/Slot2").set_deferred("disabled",true)
	else:
		var b = player.load_game("./slot2.tres")
		get_node("VBoxContainer/Slot2").hint_tooltip = b.player_name
	if(!(player.save_exists("./slot3.tres"))):
		get_node("VBoxContainer/Slot3").set_deferred("disabled",true)
	else:
		var b = player.load_game("./slot3.tres")
		get_node("VBoxContainer/Slot3").hint_tooltip = b.player_name


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")

func applyVals(slotPath):
	var player = Player.new()
	var b = player.load_game(slotPath)
	get_node("/root/PlayerVariables").scrap = b.scrap
	get_node("/root/PlayerVariables").boughtUpgrades = b.boughtUpgrades
	get_node("/root/PlayerVariables").vehicleType = b.vehicleType
	get_node("/root/PlayerVariables").healthMult = b.healthMult
	get_node("/root/PlayerVariables").armorMult = b.armorMult
	get_node("/root/PlayerVariables").main_gun_level = b.main_gun_level
	get_node("/root/PlayerVariables").auto_gun_level = b.auto_gun_level
	get_node("/root/PlayerVariables").placeable_level = b.placeable_level
	get_node("/root/PlayerVariables").miscUpgrades = b.miscUpgrades
	get_node("/root/PlayerVariables").saveSlotPath = slotPath
	get_node("/root/PlayerVariables").playerName = b.player_name
	get_node("/root/Globals/AudioStreamPlayer").playing = false
	get_node("/root/Globals/ScrollingBG").move = false
	get_tree().change_scene("res://Scenes/MainMap.tscn")

#save values to playervariables
func _on_Slot1_pressed():
	applyVals("./slot1.tres")

func _on_Slot2_pressed():
	applyVals("./slot2.tres")


func _on_Slot3_pressed():
	applyVals("./slot3.tres")
