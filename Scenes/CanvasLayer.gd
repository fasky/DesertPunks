extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../Player").scrap = get_node("/root/PlayerVariables").scrap
	get_tree().paused = true

func updateScrapLabelMenu():
	get_node("UpgradeMenu/ScrapLabelUpgradeMenu").text = str(get_node("/root/PlayerVariables").scrap)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	updateScrapLabelMenu()
	updateBars()

func _input(event):
	if(event.is_action_pressed("pause_game") && !get_node("../Player").dying):
		$PauseShader.visible = true
		get_tree().paused = true
		get_node("PauseMenu").show()
		get_node("ScrapLabel").hide()
		get_node("Health").hide()
		get_node("Armor").hide()
		get_node("Frame").hide()
		get_node("FrameTop").hide()
		get_node("IndicatorBG").hide()
		get_node("MainGunIndicator").hide()
		get_node("BoostIndicator").hide()
		get_node("ChainAttack").hide()
		get_node("SlowIndicator").hide()
		get_node("Placeable").hide()

func _on_Exit_pressed():
	$PauseShader.visible = false
	get_tree().paused = false
	get_node("/root/Globals/AudioStreamPlayer").playing = true
	get_node("/root/Globals/ScrollingBG").move = true
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Resume_pressed():
	$PauseShader.visible = false
	get_node("PauseMenu").hide()
	get_node("ScrapLabel").show()
	get_node("Health").show()
	get_node("Armor").show()
	get_node("Frame").show()
	get_node("FrameTop").show()
	get_node("IndicatorBG").show()
	get_node("MainGunIndicator").show()
	get_node("BoostIndicator").show()
	if(get_node("../Player").chainAttack):
		get_node("ChainAttack").show()
	get_node("SlowIndicator").show()
	if(get_node("../Player").placeable_level != -1):
		get_node("Placeable").show()
	get_tree().paused = false


func _on_Start_pressed():
	$PauseShader.visible = false
	get_node("../Player/Spawner").new_wave(0)
	get_node("PauseMenu").hide()
	get_node("UpgradeMenuBG").hide()
	get_node("UpgradeMenu").hide()
	get_node("ScrapLabel").show()
	var currentHealth = get_node("../Player").health
	var currentArmor = get_node("../Player").armor
	var currentBoost = get_node("../Player").boostAmount
	var currentChain = get_node("../Player").chainAttackCounter
	var currentSlow = get_node("../Player").slowTimeCounter
	var currentPlace = get_node("../Player").placeable_counter
	get_node("Health").show()
	get_node("Armor").show()
	get_node("IndicatorBG").show()
	get_node("Frame").show()
	get_node("FrameTop").show()
	get_node("MainGunIndicator").show()
	get_node("BoostIndicator").show()
	get_node("SlowIndicator").show()
	if(get_node("../Player").chainAttack):
		get_node("ChainAttack").show()
	if(get_node("../Player").placeable_level != -1):
		get_node("Placeable").show()
	get_node("Health").max_value = currentHealth
	get_node("Armor").max_value = currentArmor
	get_node("ChainAttack").max_value = currentChain
	get_node("Placeable").max_value = currentPlace
	get_tree().paused = false

func updateAllMenus():
	get_node("UpgradeMenu/Armor").updateMenu()
	get_node("UpgradeMenu/Health").updateMenu()
	get_node("UpgradeMenu/Vehicle").updateMenu()
	get_node("UpgradeMenu/MainGun").updateMenu()
	get_node("UpgradeMenu/AutoFire").updateMenu()
	get_node("UpgradeMenu/Placeable").updateMenu()
	get_node("UpgradeMenu/Specials").updateMenu()
	
func updateBars():
	var currentHealth = get_node("../Player").health
	var currentArmor = get_node("../Player").armor
	var currentBoost = get_node("../Player").boostAmount
	var currentChain = get_node("../Player").chainAttackCounter
	var currentSlow = get_node("../Player").slowTimeCounter
	var currentPlace = get_node("../Player").placeable_counter
	if(get_node("../Player").fired):
		get_node("MainGunIndicator").value = 0
	else:
		get_node("MainGunIndicator").value = 100
	get_node("Health").value = currentHealth
	get_node("Armor").value = currentArmor
#	get_node("Boost").value = currentBoost
	if(get_node("../Player").boost):
		get_node("BoostIndicator").rect_rotation = (currentBoost / 5)
	else:
		get_node("BoostIndicator").rect_rotation = 0
	get_node("ChainAttack").value = currentChain
#	get_node("SlowTime").value = currentSlow
	if(get_node("../Player").slowTime):
		get_node("SlowIndicator").rect_rotation = 240.0 + (currentSlow / 5)
	else:
		get_node("SlowIndicator").rect_rotation = 240
	get_node("Placeable").value = currentPlace


func _on_Back_pressed():
	get_node("/root/Globals/AudioStreamPlayer").playing = true
	get_node("/root/Globals/ScrollingBG").move = true
	print(get_node("/root/Globals/ScrollingBG").move)
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Button_pressed():
	$UpgradeMenu/PopUpBG.visible = false
	$UpgradeMenu/Vehicle.visible = false
	$UpgradeMenu/Health.visible = false
	$UpgradeMenu/Armor.visible = false
	$UpgradeMenu/MainGun.visible = false
	$UpgradeMenu/AutoFire.visible = false
	$UpgradeMenu/Placeable.visible = false
	$UpgradeMenu/Button.visible = false
	$UpgradeMenu/UpgradeDesc.visible = false
