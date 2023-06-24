extends Position2D

export var enemiesKilled = []
export var countdowns = []
export var respawnTimeBase = [20,35,60,90,120,140,160,0]
var respawnTime = []
export var numEnemyTypes = 8
export(PackedScene) var enemyBase
export(PackedScene) var platformBoss
export(PackedScene) var tankBoss
export(PackedScene) var supertankerBoss
export(PackedScene) var wormBoss
export(PackedScene) var waveWords
export var spawns = []
var rng = RandomNumberGenerator.new()
var enemyCount = []
export var maxEnemies = []
var targetHit = [false,false,false,false,false,false,false,false]
var wave = 88
var waveCheckTimerMax = 60
var waveCheckTimer = 60

# Called when the node enters the scene tree for the first time.
func _ready():
	spawns = get_children()
	respawnTime = respawnTimeBase.duplicate()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	checkIfShouldSpawn()
	waveCheckTimer -= 1
	if(waveCheckTimer < 1):
		checkIfNextWave()
		waveCheckTimer = waveCheckTimerMax

func checkIfNextWave():
	var i = 0
	var nextWaveStart = true
	while(i < numEnemyTypes):
		nextWaveStart = targetHit[i]
		if(nextWaveStart == false):
			i = numEnemyTypes
		else:
			i+= 1
	if(nextWaveStart):
		wave += 1
		new_wave(wave)

func checkIfShouldSpawn():
	var i = 0
	while(i < numEnemyTypes):
		if(!targetHit[i]):
			countdowns[i] += 1
			if((countdowns[i] >= respawnTime[i]) && (enemyCount[i] < (maxEnemies[i] - enemiesKilled[i]))):
				spawn_enemy(i)
			# check if enough enemies killed to progress wave
			if ((maxEnemies[i] - enemiesKilled[i]) <= 0):
				targetHit[i] = true
		i += 1

func new_wave(waveNext):
	targetHit = [false,false,false,false,false,false,false,false]
	enemiesKilled = [0,0,0,0,0,0,0,0]
	countdowns = [0,0,0,0,0,0,0,0]
	enemyCount = [0,0,0,0,0,0,0,0]
	maxEnemies = maxEnemiesPerWaveDict[waveNext]
	var b = waveWords.instance()
	b.wave = wave + 1
	get_node("/root/Rooter/CanvasLayer").add_child(b)
	

func spawn_enemy(i):
	if(i < 7):
		var b = enemyBase.instance()
		b.init(i, wave)
		rng.randomize()
		var my_random_number = rng.randi_range(0, spawns.size()-1)
		b.position = spawns[my_random_number].global_position
		owner.get_parent().add_child(b)
		countdowns[i] = 0
		enemyCount[i] += 1
	else:
		if(wave == 9): #Tank
			var b = tankBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,false)
			countdowns[i] = 0
			enemyCount[i] += 1
		if(wave == 19): #Super tanker
			var b = supertankerBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,false)
			countdowns[i] = 0
			enemyCount[i] += 1
		if(wave == 29): #worm
			var b = wormBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,false)
			countdowns[i] = 0
			enemyCount[i] += 1
		if(wave == 89): #platform
			var b = platformBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			countdowns[i] = 0
			enemyCount[i] += 1
		elif(wave == 49): # super tank
			var b = tankBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,true)
			countdowns[i] = 0
			enemyCount[i] += 1
		elif(wave == 59): # super mega tanker
			var b = supertankerBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,true)
			countdowns[i] = 0
			enemyCount[i] += 1
		elif(wave == 69): #mega worm
			var b = wormBoss.instance()
			rng.randomize()
			var my_random_number = rng.randi_range(0, spawns.size()-1)
			b.position = spawns[my_random_number].global_position
			owner.get_parent().add_child(b)
			b.init(true,true)
			countdowns[i] = 0
			enemyCount[i] += 1

var maxEnemiesPerWaveDict = {
	0: [10,0,0,0,0,0,0,0],
	1: [10,1,0,0,0,0,0,0],
	2: [15,5,0,0,0,0,0,0],
	3: [15,5,1,0,0,0,0,0],
	4: [20,10,1,0,0,0,0,0],
	5: [20,10,5,0,0,0,0,0],
	6: [25,10,5,0,0,0,0,0],
	7: [25,15,5,0,0,0,0,0],
	8: [25,15,10,0,0,0,0,0],
	9: [10,10,10,0,0,0,0,1], #boss wave Tank
	10: [20,10,1,0,0,0,0,0],
	11: [20,10,5,0,0,0,0,0],
	12: [25,10,5,0,0,0,0,0],
	13: [25,15,5,0,0,0,0,0],
	14: [25,15,10,0,0,0,0,0],
	15: [25,15,10,1,0,0,0,0],
	16: [25,20,10,1,0,0,0,0],
	17: [30,25,10,5,0,0,0,0],
	18: [30,25,15,5,0,0,0,0],
	19: [20,10,10,1,0,0,0,2], #boss wave Super Tanker
	20: [25,15,10,0,0,0,0,0],
	21: [25,15,10,1,0,0,0,0],
	22: [25,20,10,1,0,0,0,0],
	23: [30,25,10,5,0,0,0,0],
	24: [30,25,15,5,0,0,0,0],
	25: [35,25,15,5,1,0,0,0],
	26: [35,25,15,5,1,0,0,0],
	27: [35,30,15,10,1,0,0,0],
	28: [40,35,20,10,5,0,0,0],
	29: [20,15,10,5,1,0,0,1], #boss wave Worm
	30: [30,25,15,5,0,0,0,0],
	31: [35,25,15,5,1,0,0,0],
	32: [35,25,15,5,1,0,0,0],
	33: [35,30,15,10,1,0,0,0],
	34: [40,30,20,10,5,0,0,0],
	35: [40,35,20,15,5,0,0,0],
	36: [40,35,20,15,10,1,0,0],
	37: [40,35,20,15,10,5,0,0],
	38: [40,40,30,20,15,5,0,0],
	39: [400,0,0,0,0,0,0,0], #boss wave Kamikaze wave
	40: [40,30,20,10,5,0,0,0],
	41: [40,35,20,15,5,0,0,0],
	42: [40,35,20,15,10,1,0,0],
	43: [40,35,20,15,10,5,0,0],
	44: [40,40,30,20,15,5,0,0],
	45: [45,40,30,20,15,5,1,0],
	46: [45,45,30,20,15,5,1,0],
	47: [45,45,35,25,15,5,5,0],
	48: [50,50,40,25,15,10,5,0],
	49: [25,25,25,25,10,5,1,1], #boss wave Super Tank
	50: [40,40,30,20,15,5,0,0],
	51: [45,40,30,20,15,5,1,0],
	52: [45,45,30,20,15,5,1,0],
	53: [45,45,35,25,15,5,5,0],
	54: [45,45,40,25,15,10,5,0],
	55: [50,45,40,25,15,10,5,0],
	56: [50,50,40,25,15,10,5,0],
	57: [50,50,45,25,20,10,5,0],
	58: [50,50,45,25,25,10,10,0],
	59: [50,25,12,6,3,2,1,2], #boss wave Supreme tanker
	60: [45,45,40,25,15,10,5,0],
	61: [50,45,40,25,15,10,5,0],
	62: [50,50,40,25,15,10,5,0],
	63: [50,50,45,25,20,10,5,0],
	64: [50,50,45,25,25,10,10,0],
	65: [50,50,45,30,25,10,10,0],
	66: [50,50,50,30,25,10,10,0],
	67: [50,50,50,30,30,15,10,0],
	68: [50,50,50,35,30,15,15,0],
	69: [50,25,15,5,5,5,5,1], #boss wave Giant Worm
	70: [50,50,45,25,25,10,10,0],
	71: [50,50,45,30,25,10,10,0],
	72: [50,50,50,30,25,10,10,0],
	73: [50,50,50,30,30,15,10,0],
	74: [50,50,50,35,30,15,15,0],
	75: [50,50,50,40,30,15,15,0],
	76: [50,50,50,40,30,20,15,0],
	77: [50,50,50,40,30,20,15,0],
	78: [50,50,50,45,35,20,20,0],
	79: [100,100,100,100,100,100,100,0], #boss wave Lots of everything
	80: [50,50,50,35,30,15,15,0],
	81: [50,50,50,40,30,15,15,0],
	82: [50,50,50,40,30,20,15,0],
	83: [50,50,50,40,30,20,15,0],
	84: [50,50,50,45,35,20,20,0],
	85: [50,50,50,50,40,25,25,0],
	86: [50,50,50,50,45,30,25,0],
	87: [50,50,50,50,45,30,30,0],
	88: [50,50,50,50,50,40,40,0],
	89: [0,0,0,0,0,0,0,1], #boss wave Platform
	90: [50,50,50,50,40,25,25,0],
	91: [50,50,50,50,45,30,25,0],
	92: [50,50,50,50,45,30,30,0],
	93: [50,50,50,50,50,35,35,0],
	94: [50,50,50,50,50,40,35,0],
	95: [50,50,50,50,50,45,40,0],
	96: [50,50,50,50,50,50,40,0],
	97: [50,50,50,50,50,50,45,0],
	98: [50,50,50,50,50,50,50,0],
	99: [0,0,0,0,0,0,0,1] #boss wave Super platform
}
