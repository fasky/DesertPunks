extends Position2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var worldTileWidth = 3072
export var worldTileHeight = 3072
var worldTiles
var currentToMoveEast = [0,3,6]
var currentToMoveEastOriginal = [0,3,6]
var currentToMoveWest = [2,5,8]
var currentToMoveWestOriginal = [2,5,8]
var currentToMoveNorth = [6,7,8]
var currentToMoveNorthOriginal = [6,7,8]
var currentToMoveSouth = [0,1,2]
var currentToMoveSouthOriginal = [0,1,2]

# Called when the node enters the scene tree for the first time.
func _ready():
	worldTiles = [get_node("../WorldTile1"),get_node("../WorldTile2"),get_node("../WorldTile3"),get_node("../WorldTile4"),get_node("../WorldTile5"),get_node("../WorldTile6"),get_node("../WorldTile7"),get_node("../WorldTile8"),get_node("../WorldTile9"),]


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_East_area_entered(area):
	if(area.is_in_group("PlayerCollider")):
		if(currentToMoveEast[0] >= 3):
			currentToMoveEast = currentToMoveEastOriginal.duplicate()
		position.x = position.x + worldTileWidth
		var i = 0
		for x in currentToMoveEast:
			currentToMoveWest[i] = x
			worldTiles[x].position.x += (worldTileWidth*3)
			currentToMoveEast[i] += 1
			i += 1

func _on_West_area_entered(area):
	if(area.is_in_group("PlayerCollider")):
		if(currentToMoveWest[0] <= -1):
			currentToMoveWest = currentToMoveWestOriginal.duplicate()
		position.x = position.x - worldTileWidth
		var i = 0
		for x in currentToMoveWest:
			currentToMoveEast[i] = x
			worldTiles[x].position.x -= (worldTileWidth*3)
			currentToMoveWest[i] -= 1
			i += 1

func _on_North_area_entered(area):
	if(area.is_in_group("PlayerCollider")):
		if(currentToMoveNorth[0] <= -3):
			currentToMoveNorth = currentToMoveNorthOriginal.duplicate()
		position.y = position.y - worldTileHeight
		var i = 0
		for x in currentToMoveNorth:
			currentToMoveSouth[i] = x
			worldTiles[x].position.y -= (worldTileHeight*3)
			currentToMoveNorth[i] -= 3
			i += 1

func _on_South_area_entered(area):
	if(area.is_in_group("PlayerCollider")):
		if(currentToMoveSouth[0] >= 9):
			currentToMoveSouth = currentToMoveSouthOriginal.duplicate()
		position.y = position.y + worldTileHeight
		var i = 0
		for x in currentToMoveSouth:
			currentToMoveNorth[i] = x
			worldTiles[x].position.y += (worldTileHeight*3)
			currentToMoveSouth[i] += 3
			i += 1
