extends BaseCulor
class_name MeleeCulor

@export var damage = 4

var targeted = false
var TargetEnemy

func target(Enemy : BaseEnemy):
	move(Enemy.global_position)
	targetcutoff = attackRange

func _ready():
	setupculor()
	
	attackTimer.wait_time = attackCooldown
	attackTimer.timeout.connect(attacktimerend)
	attackTimer.start()

func attacktimerend():
	await loopUntilRange()
	Animator.play("attack_melee")
	attackTimer.start()
