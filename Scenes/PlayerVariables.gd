extends Node

# Declare member variables here. Examples:
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
export var scrap = 0
export var saveSlotPath = "./slot1.tres"
export var playerName = "Name"
export var vehicle0Stats = {
	"armor" : 50,
	"health": 100,
	"enginePower": 630,
	"steeringAngle": 5,
	"wheelBase": 15,
	"baseTurnSpeed": 450,
	"friction": -0.3,
	"drag": -0.001,
	"braking": -400,
	"maxSpeedReverse": 300,
	"slipSpeed": 450,
	"tractionFastBase": 0.5,
	"tractionSlow": 0.85,
	"mass": 60
}
export var vehicle1Stats = {
	"armor" : 100,
	"health": 120,
	"enginePower": 750,
	"steeringAngle": 5,
	"wheelBase": 15,
	"baseTurnSpeed": 450,
	"friction": -0.3,
	"drag": -0.001,
	"braking": -400,
	"maxSpeedReverse": 300,
	"slipSpeed": 450,
	"tractionFastBase": 0.5,
	"tractionSlow": 0.85,
	"mass": 100
}
export var vehicle2Stats = {
	"armor" : 100,
	"health": 250,
	"enginePower": 450,
	"steeringAngle": 10,
	"wheelBase": 50,
	"baseTurnSpeed": 325,
	"friction": -0.2,
	"drag": -0.001,
	"braking": -350,
	"maxSpeedReverse": 250,
	"slipSpeed": 400,
	"tractionFastBase": 0.4,
	"tractionSlow": 0.8,
	"mass": 300
}
export var vehicle3Stats = {
	"armor" : 200,
	"health": 250,
	"enginePower": 450,
	"steeringAngle": 10,
	"wheelBase": 50,
	"baseTurnSpeed": 325,
	"friction": -0.2,
	"drag": -0.001,
	"braking": -350,
	"maxSpeedReverse": 250,
	"slipSpeed": 400,
	"tractionFastBase": 0.4,
	"tractionSlow": 0.8,
	"mass": 350
}
export var vehicle4Stats = {
	"armor" : 300,
	"health": 500,
	"enginePower": 450,
	"steeringAngle": 10,
	"wheelBase": 50,
	"baseTurnSpeed": 325,
	"friction": -0.2,
	"drag": -0.001,
	"braking": -350,
	"maxSpeedReverse": 250,
	"slipSpeed": 400,
	"tractionFastBase": 0.4,
	"tractionSlow": 0.8,
	"mass": 400
}
export var vehicle5Stats = {
	"armor" : 500,
	"health": 500,
	"enginePower": 450,
	"steeringAngle": 10,
	"wheelBase": 50,
	"baseTurnSpeed": 325,
	"friction": -0.2,
	"drag": -0.001,
	"braking": -350,
	"maxSpeedReverse": 250,
	"slipSpeed": 400,
	"tractionFastBase": 0.4,
	"tractionSlow": 0.8,
	"mass": 500
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func resetVals():
	boughtUpgrades = ["Health1","Type1","Armor1","MainGun1"]
	vehicleType = 0
	healthMult = 0
	armorMult = 0
	main_gun_level = 0
	auto_gun_level = 0
	placeable_level = -1
	miscUpgrades = [false,false,false,false,false,false]
	scrap = 0
