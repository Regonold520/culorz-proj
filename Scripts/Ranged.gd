extends BaseCulor
class_name RangedCulor

@export var Maxdamage = 4
@export var damage = 4

@export var BulletType : PackedScene

var targeted = false
var TargetEnemy : BaseEnemy = null

func move(pos : Vector2, resetenemy = true):
	# round target position
	targetposition = Vector2(round(pos.x),round(pos.y))
	
	if resetenemy:
		targetcutoff = 1
		TargetEnemy = null

func target(Enemy : BaseEnemy):
	move(Enemy.global_position, false) #move towards enemy, dont reset.
	targetcutoff = attackRange
	TargetEnemy = Enemy

func _process(delta):
	if TargetEnemy != null:
		move(TargetEnemy.global_position, false)  #move towards enemy, dont reset.
		if position.distance_to(TargetEnemy.global_position) <= attackRange: #if within range, play attack_melee
			if abs(position.angle_to_point(TargetEnemy.global_position)) <= deg_to_rad(90):
				Animator.play("attack_melee_flipped")
			else:
				Animator.play("attack_melee")

func animation_hit(): #activated by the animation.
	if TargetEnemy != null:
		var bullet : Bullet = BulletType.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_rotation = position.angle_to_point(TargetEnemy.position)
		bullet.linear_velocity = (position.direction_to(TargetEnemy.position) * bullet.Movespeed)
		bullet.Shooter = self
		bullet.Damage = damage
