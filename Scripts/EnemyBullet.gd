extends RigidBody2D
class_name EnemyBullet

@export var Movespeed = 10
@export var Pierce = false
@export var expiration = 10

var Shooter = null
var Damage = 10
var hitenemies = []

func _ready() -> void:
	await get_tree().create_timer(expiration).timeout
	queue_free()

func _on_area_2d_area_entered(area):
	if area.has_meta("BulletStopping"):
		queue_free()
		return
	if area.get_parent():
		if area.get_parent() is BaseCulor:
			if !hitenemies.has(area):
				hitenemies.append(area)
				if area.get_parent().has_method("hit"):
					if area.get_parent() != null:
						area.get_parent().hit(Damage,Shooter)
						if !Pierce:
							queue_free()
