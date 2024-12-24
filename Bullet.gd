extends RigidBody2D
class_name Bullet

@export var Movespeed = 10
@export var Pierce = false
var Shooter = null
var Damage = 10
var hitenemies = []


func _on_area_2d_area_entered(area):
	if area.get_parent():
		if area.get_parent() is BaseEnemy:
			if !hitenemies.has(area):
				hitenemies.append(area)
				area.get_parent().hit(Damage,Shooter)
				if !Pierce:
					queue_free()
