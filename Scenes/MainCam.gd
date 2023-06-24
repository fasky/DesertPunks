extends Camera2D

var interpolate_val = 0
onready var player = get_node("../Player")
# How quickly to move through the noise
export var NOISE_SHAKE_SPEED: float = 30.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
export var NOISE_SHAKE_STRENGTH: float = 60.0
# Multiplier for lerping the shake strength to zero
export var SHAKE_DECAY_RATE: float = 5.0
onready var rand = RandomNumberGenerator.new()
onready var noise = OpenSimplexNoise.new()
# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

var shake_strength: float = 5.0

func _ready():
	rand.randomize()
	noise.seed = rand.randi()
	# Period affects how quickly the noise changes values
	noise.period = 2
	
func apply_noise_shake():
	shake_strength = NOISE_SHAKE_STRENGTH

func _process(delta):
	if(shake_strength > 5.0):
		SHAKE_DECAY_RATE = 4.0
		NOISE_SHAKE_SPEED = 30.0
		NOISE_SHAKE_STRENGTH = 60.0
	else:
		SHAKE_DECAY_RATE = 0.0
		NOISE_SHAKE_SPEED = 2.0
		NOISE_SHAKE_STRENGTH = 6.0
		shake_strength = 5.0
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)
	offset = get_noise_offset(delta)
	
func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)

func _physics_process(_delta):
#	var mid_x = (player.position.x + get_global_mouse_position().x) / 3
#	var mid_y = (player.position.y + get_global_mouse_position().y) / 2
#
#	position = position.linear_interpolate(Vector2(mid_x,mid_y), interpolate_val * delta) 
	
	position.x = player.position.x
	position.y = player.position.y
