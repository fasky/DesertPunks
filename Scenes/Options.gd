extends Control


#onready var drop_down_menu = $VBoxContainer/VBoxContainer/ResolutionMenu
var resolutionIndex
export(ButtonGroup) var buttonGroup

# Called when the node enters the scene tree for the first time.
func _ready():
	resolutionIndex = get_node("/root/Globals").selectedWindowedRes
	var group = buttonGroup.get_buttons()
	for button in group:
		button.connect("pressed", self, "_on_ResolutionMenu_item_selected")
		if(button.name == str(resolutionIndex)):
			button.pressed = true
		else:
			button.pressed = false
	if(OS.window_fullscreen):
		get_node("VBoxContainer/HBoxContainer/CheckBox").pressed = true
	else:
		get_node("VBoxContainer/HBoxContainer/CheckBox").pressed = false

func _on_Back_pressed():
	get_node("/root/Globals").overwriteSettings()
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_ResolutionMenu_item_selected():
	var index = int(buttonGroup.get_pressed_button().name)
	match index:
		0: 
			OS.set_window_size(Vector2(800,480))
		1: 
			OS.set_window_size(Vector2(1024,576))
		2: 
			OS.set_window_size(Vector2(1280,720))
		3: 
			OS.set_window_size(Vector2(1600,900))
		4: 
			OS.set_window_size(Vector2(1920,1080))
		5: 
			OS.set_window_size(Vector2(2560,1080))
		6: 
			OS.set_window_size(Vector2(2560,1440))
			
	get_node("/root/Globals").selectedWindowedRes = index


func _on_CheckBox_toggled(button_pressed):
	OS.window_fullscreen = button_pressed
	get_node("/root/Globals").fullscreen = button_pressed	
	if(!button_pressed):
		_on_ResolutionMenu_item_selected()
