extends KinematicBody2D


var enemyPlaceable = false
var wormAttack = false
var mine = false
var bomb = false
var megaBomb = false
var scatteredBombs = false
var blackHole = false
var nails = false
var nailsTimer = 600
var blowingUp = false
var timerQ = 25

var toKill = []

var damage = 200

var targetPosBomb
var speed = 500
var i = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if(bomb || scatteredBombs):
		$BombScatter.visible = true
		$Explosion.scale = Vector2(8,8)
		$MineBombArea2D/CollisionShape2D.set_deferred("disabled", false)
	elif(wormAttack):
		$WormRock.visible = true
		$Explosion.scale = Vector2(4,4)
		$EnemyBombTrigger/CollisionShape2D.set_deferred("disabled", false)
		$MineTrigger/CollisionShape2D.set_deferred("disabled", false)
	elif(mine):
		$Mine.visible = true
		$Explosion.scale = Vector2(8,8)
		$MineBombArea2D/CollisionShape2D.set_deferred("disabled", false)
		$MineTrigger/CollisionShape2D.set_deferred("disabled", false)
	elif(enemyPlaceable):
		$EnemyBomb.visible = true
		$Explosion.scale = Vector2(3,3)
		$EnemyBombTrigger/CollisionShape2D.set_deferred("disabled", false)
		$MineTrigger/CollisionShape2D.set_deferred("disabled", false)
	elif(megaBomb):
		$MegaBomb.visible = true
		$Explosion.scale = Vector2(14,14)
		$MegaBombArea2D/CollisionShape2D.set_deferred("disabled", false)
	elif(blackHole):
		$BlackHoleSprite.visible = true
		$Explosion.scale = Vector2(24,24)
		$BlackHole/CollisionShape2D.set_deferred("disabled", false)
	else:
		$Nails.visible = true
		$Nails.playing = true
		$NailsArea2D/CollisionShape2D.set_deferred("disabled", false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if(!blowingUp && (bomb || megaBomb || scatteredBombs || blackHole || enemyPlaceable || wormAttack)):
		rotation_degrees += 15.0
		var direction = global_position.direction_to(targetPosBomb)
		var velocity = direction * speed
		position += (velocity.normalized()*(speed/100))
		if((global_position.x >= (targetPosBomb.x - 10) && global_position.x <= (targetPosBomb.x + 10)) && (global_position.y >= (targetPosBomb.y - 5) && global_position.y <= (targetPosBomb.y + 5))):
			blowUp()
			$BombScatter.visible = false
			$Mine.visible = false
			$EnemyBomb.visible = false
			$MegaBomb.visible = false
			$BlackHoleSprite.visible = false
			$WormRock.visible = false
	elif(blowingUp):
		timerQ -= 1
		if(timerQ < 1):
			queue_free()
	elif(nails):
		nailsTimer -= 1
		$Nails.modulate.a -= .0015
		if(nailsTimer <= 0):
			queue_free()
			

#mine, bomb, scatter bombs area2d kill list adder/remover
func _on_Area2D_body_entered(body):
	if(mine || scatteredBombs || bomb):
		if body.is_in_group("Enemy") || body.is_in_group("Platform"):
			toKill.append(body)

func _on_Area2D_body_exited(body):
	if(mine || scatteredBombs || bomb):
		if (body.is_in_group("Enemy") || body.is_in_group("Player") || body.is_in_group("Friendly") || body.is_in_group("Platform")):
			toKill.erase(body)

func blowUp():
	if(!blowingUp):
		if(!$Explosion.playing):
			$Explosion.playFX()
			blowingUp = true
		
		for veh in toKill:
			if(is_instance_valid(veh) && !veh.dying):
				if(veh.is_in_group("Platform")):
					veh.health -= damage/50
					get_node("/root/Rooter/CanvasLayer/Frame/BossBar").value = veh.health
				else:
					veh.damage(damage)

#mine trigger killer
func _on_MineTrigger_body_entered(body):
	if(mine):
		if body.is_in_group("Enemy") || body.is_in_group("Platform"):
			$MineTrigger/CollisionShape2D.set_deferred("disabled", true)
			blowUp()
	elif(enemyPlaceable || wormAttack):
		if body.is_in_group("Player") || body.is_in_group("Friendly"):
			$MineTrigger/CollisionShape2D.set_deferred("disabled", true)
			blowUp()

#mega bomb kill lister
func _on_MegaBombArea2D_body_entered(body):
	if(megaBomb):
		if body.is_in_group("Enemy") || body.is_in_group("Platform"):
			toKill.append(body)


func _on_MegaBombArea2D_body_exited(body):
	if(megaBomb):
		if (body.is_in_group("Enemy")) || body.is_in_group("Platform"):
			toKill.erase(body)

#nails - stop enemy movement here
func _on_NailsArea2D_body_entered(body):
	if(nails):
		if body.is_in_group("Enemy"):
			body.canMove = false

#set to kill
func _on_BlackHole_body_entered(body):
	if(blackHole):
		if body.is_in_group("Enemy") || body.is_in_group("Platform"):
			toKill.append(body)


func _on_EnemyBombTrigger_body_entered(body):
	if(enemyPlaceable || wormAttack):
		if body.is_in_group("Player") || body.is_in_group("Friendly"):
			toKill.append(body)


func _on_EnemyBombTrigger_body_exited(body):
	if(enemyPlaceable || wormAttack):
		if body.is_in_group("Player") || body.is_in_group("Friendly"):
			toKill.erase(body)


func _on_Explosion_animation_finished():
	if(i == 1):
		queue_free()
	i += 1
