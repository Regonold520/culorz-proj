extends BaseCulor
class_name SupportCulor

@export var damage = 4
@export var friendlyTarget = false

var targeted = false
var Target = null

func move(pos : Vector2, resetenemy = true):
	# round target position
	targetposition = Vector2(round(pos.x),round(pos.y))
	
	if resetenemy:
		targetcutoff = 1
		Target = null

func target(Enemy):
	move(Enemy.global_position, false) #move towards enemy, dont reset.
	targetcutoff = attackRange
	Target = Enemy

func _process(delta):
	if Target != null:
		move(Target.global_position, false)  #move towards enemy, dont reset.
		if position.distance_to(Target.global_position) <= attackRange: #if within range, play attack_melee
			if abs(position.angle_to_point(Target.global_position)) <= deg_to_rad(90):
				Animator.play("attack_melee_flipped")
			else:
				Animator.play("attack_melee")

func animation_hit():
	if Target != null:
		pass

func get_enemies():
	var distance = 999
	var distanceholder = null
	for Culor in get_tree().get_nodes_in_group("Enemies"):
		if position.distance_to(Culor.position) <= attackRange:
			if distance >= position.distance_to(Culor.position):
				distance = position.distance_to(Culor.position)
				distanceholder = Culor
	if distance == 999:
		return false
	else:
		return distanceholder
		
func get_culorz():
	var distance = 999
	var distanceholder = null
	for Culor in get_tree().get_nodes_in_group("Culorz"):
		if position.distance_to(Culor.position) <= attackRange:
			if distance >= position.distance_to(Culor.position):
				distance = position.distance_to(Culor.position)
				distanceholder = Culor
	if distance == 999:
		return false
	else:
		return distanceholder
