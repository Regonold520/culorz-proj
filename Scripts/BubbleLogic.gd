extends RangedCulor

var curentBulletRotation = 0

func animation_hit():
	if TargetEnemy != null:
		var bullet : Bullet = BulletType.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = position.angle_to_point(TargetEnemy.position)
		bullet.linear_velocity = (Vector2(cos(curentBulletRotation), sin(curentBulletRotation)) * bullet.Movespeed)
		bullet.Shooter = self
		bullet.Damage = damage
		
		curentBulletRotation += deg_to_rad(62)
