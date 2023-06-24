extends Sprite

var rng = RandomNumberGenerator.new()
export var sprites = []

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	var s = rng.randi_range(0,sprites.size()-1)
	texture = load(sprites[s])

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
