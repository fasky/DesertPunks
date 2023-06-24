extends HBoxContainer

export var upgrades = []
export var upgradesCost = []
export var upgradeBought = []
export var health = false
export var armor = false
export var main = false
export var auto = false
export var placeable = false
export var type = false
export var specials = false

export var descriptions = ["","","","","",""]

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = 0
	for button in upgrades:
		get_node(button).connect("pressed", self, "_on_upgrade_pressed", [button])
		get_node(button).connect("mouse_entered", self, "_on_upgrade_hover", [button])
		get_node(button).connect("mouse_exited", self, "_on_upgrade_unhover", [button])
		if(get_node("/root/PlayerVariables").boughtUpgrades.find(get_node(button).name) != -1):
			upgradeBought[i] = true
		i += 1
	updateMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func updateMenu():
	var i = 0
	for upgrade in upgrades:
		if(upgradeBought[i]):
			get_node(upgrade).set_deferred("disabled",false)
			upgradesCost[i] = 0
		elif(upgradesCost[i] <= get_node("/root/PlayerVariables").scrap):
			get_node(upgrade).set_deferred("disabled",false)
			get_node(upgrade).modulate = "696969"
		else:
			get_node(upgrade).set_deferred("disabled",true)
			get_node(upgrade).modulate = "181818"
		if(upgradesCost[i] == 0):
			if(type):
				var t = get_node("/root/PlayerVariables").vehicleType
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			elif(health):
				var t = get_node("/root/PlayerVariables").healthMult
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp2").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			elif(armor):
				var t = get_node("/root/PlayerVariables").armorMult
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp3").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			elif(main):
				var t = get_node("/root/PlayerVariables").main_gun_level
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp5").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			elif(auto):
				var t = get_node("/root/PlayerVariables").auto_gun_level
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp4").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			elif(placeable):
				var t = get_node("/root/PlayerVariables").placeable_level
				if(t == i):
					get_node(upgrade).modulate = "ffffff"
					get_node("../PopUp6").icon = get_node(upgrade).icon
				else:
					get_node(upgrade).modulate = "c8c8c8"
			else:
				if get_node("/root/PlayerVariables").miscUpgrades[i]:
					get_node(upgrade).modulate = "ffffff"
				else:
					get_node(upgrade).modulate = "c8c8c8"
		i += 1


func _on_upgrade_hover(button):
	var desc = descriptions[upgrades.find(button)]
	
	if(upgradeBought[upgrades.find(button)]):
		desc = "Bought - " + desc
	else:
		desc = str(upgradesCost[upgrades.find(button)]) + " - " + desc
		
	if(specials):
		get_node("../SpecialsDesc").text = desc
	else:
		get_node("../UpgradeDesc").text = desc
	
func _on_upgrade_unhover(button):
	if(specials):
		get_node("../SpecialsDesc").text = "Mouse over a special upgrade to view its details."
	else:
		get_node("../UpgradeDesc").text = "Mouse over an upgrade to view its details."
	
func _on_upgrade_pressed(button):
	var upgradeIndex = upgrades.find(button)
	if(upgradeBought[upgradeIndex]):
		if(!specials):
			setUpgrade(upgradeIndex)
		else:
			if(get_node("/root/PlayerVariables").miscUpgrades[upgradeIndex]):
				unsetSpecial(upgradeIndex)
			else:
				setUpgrade(upgradeIndex)
		updateMenu()
	elif(upgradesCost[upgradeIndex] <= get_node("/root/PlayerVariables").scrap):
		get_node("/root/PlayerVariables").scrap -= upgradesCost[upgradeIndex]
		get_node("/root/PlayerVariables").boughtUpgrades.append(get_node(button).name)
		get_node("/root/Rooter/Player").scrap = get_node("/root/PlayerVariables").scrap
		get_node("/root/Rooter/CanvasLayer").updateScrapLabelMenu()
		upgradeBought[upgradeIndex] = true
		setUpgrade(upgradeIndex)
		get_node("/root/Rooter/CanvasLayer").updateAllMenus()

func setUpgrade(upgradeIndex):
	if(type):
		get_node("/root/PlayerVariables").vehicleType = upgradeIndex
	elif(health):
		get_node("/root/PlayerVariables").healthMult = upgradeIndex
	elif(armor):
		get_node("/root/PlayerVariables").armorMult = upgradeIndex
	elif(main):
		get_node("/root/PlayerVariables").main_gun_level = upgradeIndex
	elif(auto):
		get_node("/root/PlayerVariables").auto_gun_level = upgradeIndex
	elif(placeable):
		get_node("/root/PlayerVariables").placeable_level = upgradeIndex
	else:
		get_node("/root/PlayerVariables").miscUpgrades[upgradeIndex] = true
	get_node(upgrades[upgradeIndex]).modulate = "ffffff"
	get_node("/root/Rooter/Player").applyCarVars()

func unsetSpecial(upgradeIndex):
	get_node("/root/PlayerVariables").miscUpgrades[upgradeIndex] = false
	get_node(upgrades[upgradeIndex]).modulate = "c8c8c8"
	get_node("/root/Rooter/Player").applyCarVars()
