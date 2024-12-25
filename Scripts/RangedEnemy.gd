extends BaseEnemy
class_name RangedEnemy

@export var BulletType : PackedScene

func AttackFromAnim():
	if Target != null:
		var bullet : EnemyBullet = BulletType.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = position.angle_to_point(Target.position)
		bullet.linear_velocity = (position.direction_to(Target.position) * bullet.Movespeed)
		bullet.Shooter = self
		bullet.Damage = damage
