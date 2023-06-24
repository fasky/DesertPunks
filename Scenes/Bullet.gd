extends Area2D

# Declare member variables here. Examples:
var speed = 1400
var lifetime = 250
var playerVelocity = Vector2.ZERO
var damage = 20
var enemyBullet = false
export var chainAttack = false
onready var bulletHoleGround = preload("res://Scenes/BulletHoleGround.tscn")
var moving = true
var hitSparks = preload("res://Scenes/BumpSparks.tscn")
var creator
var type

func init(bulletSpeed:int = 1000, bulletDamage:int = 20, creater:Object = null, bulType:int = 0):
	damage = bulletDamage
	speed = bulletSpeed
	creator = creater
	type = bulType
	
func changeSprite(type):
	if(type == "Chain"):
		$Sprite.texture = load("res://Sprites/BulletChainBase.png")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	lifetime -= 1
	if(lifetime < 100):
		if(moving):
			$Sprite.visible = false
			moving = false
			add_child(bulletHoleGround.instance())
		if(lifetime < 1):
			queue_free()

func _physics_process(delta):
	if(moving):
		position += transform.x * speed * delta + playerVelocity/150
	
#func _on_Bullet_body_entered(body):
#	pass


func _on_Bullet_body_shape_entered(body_id, body, body_shape, area_shape):
	var body_shape_owner_id = body.shape_find_owner(body_shape)
	var body_shape_owner = body.shape_owner_get_owner(body_shape_owner_id)
	var body_shape_2d = body.shape_owner_get_shape(body_shape_owner_id, 0)
	var body_global_transform = body_shape_owner.global_transform

	var area_shape_owner_id = shape_find_owner(area_shape)
	var area_shape_owner = shape_owner_get_owner(area_shape_owner_id)
	var area_shape_2d = shape_owner_get_shape(area_shape_owner_id, 0)
	var area_global_transform = area_shape_owner.global_transform

	var collision_points = area_shape_2d.collide_and_get_contacts(area_global_transform, body_shape_2d, body_global_transform)
	if(!enemyBullet && moving):
		if body.is_in_group("Enemy"):
			if(chainAttack):
				var killed = []
				body.chainKill(killed,body)
			else:
				body.damage(damage)
		if(!body.is_in_group("Friendly")):
			if(collision_points.size() > 0):
				var sparks = hitSparks.instance()
				sparks.global_position = collision_points[0]
				get_parent().add_child(sparks)
				queue_free()
	elif(moving):
		if body.is_in_group("Player") || body.is_in_group("Friendly"):
			body.damage(damage)
			var sparks = hitSparks.instance()
			if(collision_points.size() > 0):
				sparks.global_position = collision_points[0]
			else:
				sparks.global_position = global_position + ((body.global_position-global_position)/2)
			get_parent().add_child(sparks)
			queue_free()
		else:
			if(creator != null):
				if(body != creator):
#					var sparks = hitSparks.instance()
#					if(collision_points.size() > 0):
#						sparks.global_position = collision_points[0]
#					else:
#						sparks.global_position = global_position + ((body.global_position-global_position)/2)
#					get_parent().add_child(sparks)
					queue_free()
			else:
				queue_free()
