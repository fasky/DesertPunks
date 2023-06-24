extends Button


export var type = ""
export var typeLabel = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = typeLabel


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_VehiclePop_pressed():
	get_node("../PopUpBG").visible = true
	get_node("../Button").visible = true
	get_node("../UpgradeDesc").visible = true
	if(type == "Vehicle"):
		get_node("../Vehicle").visible = true
	if(type == "Health"):
		get_node("../Health").visible = true
	if(type == "Armor"):
		get_node("../Armor").visible = true
	if(type == "Auto"):
		get_node("../AutoFire").visible = true
	if(type == "Main"):
		get_node("../MainGun").visible = true
	if(type == "Place"):
		get_node("../Placeable").visible = true
