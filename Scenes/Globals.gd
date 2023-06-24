extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var selectedWindowedRes = 0
var fullscreen = true
var mouseBase = load("res://Sprites/UI/MouseShoot.png")
var mousePointer = load("res://Sprites/UI/MousePointer.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_custom_mouse_cursor(mouseBase, Input.CURSOR_ARROW, Vector2(8,8))
	Input.set_custom_mouse_cursor(mousePointer, Input.CURSOR_POINTING_HAND, Vector2(14,0))
	loadSettings()
	
func overwriteSettings():
	var settingsLoader = SettingsSaver.new()
	settingsLoader.fullscreenSetting = fullscreen
	settingsLoader.windowedIndex = selectedWindowedRes
	settingsLoader.write_save("./settings.tres")

func loadSettings():
	var settingsLoader = SettingsSaver.new()
	if(settingsLoader.save_exists("./settings.tres")):
		var b = settingsLoader.load_game("./settings.tres")
		fullscreen = b.fullscreenSetting
		
		OS.window_fullscreen = fullscreen
		selectedWindowedRes = b.windowedIndex
		match selectedWindowedRes:
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
	else:
		settingsLoader.write_save("./settings.tres")
