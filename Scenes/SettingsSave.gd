extends Resource

class_name SettingsSaver

export var fullscreenSetting = true
export var windowedIndex = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func write_save(path):
	ResourceSaver.save(path, self)

static func save_exists(path) -> bool:
	return ResourceLoader.exists(path)

static func load_game(path):
	return ResourceLoader.load(path)
