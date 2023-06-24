extends Resource

class_name Player

export var player_name = ""
export var scrap = 0
export var boughtUpgrades = ["Health1","Type1","Armor1","MainGun1"]
export var vehicleType = 0
export var healthMult = 0
export var healthMultActual = [1.0,1.1,1.3,1.5,2,2.5]
export var armorMult = 0
export var armorMultActual = [1.0,1.1,1.3,1.5,2,2.5]
export var main_gun_level = 0
export var auto_gun_level = 0
export var placeable_level = -1
# Nails, mine, bomb, mega bomb, scatter bombs around player, black hole
#var boost = false
#var rammingBonus = false
#var doubleHealth = false
#var doubleArmor = false
#var chainAttack = false
#var slowTime = false
export var miscUpgrades = [false,false,false,false,false,false]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func write_save(path):
	ResourceSaver.save(path, self)

static func save_exists(path) -> bool:
	return ResourceLoader.exists(path)

static func load_game(path):
	return ResourceLoader.load(path)
