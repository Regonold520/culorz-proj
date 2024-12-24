extends CharacterBody2D
class_name BaseEnemy

@export var Maxspeed = 20
@export var speed = 20

@export var Maxhealth = 20
@export var health = 20

@export var Maxdamage = 1
@export var damage = 1

@export var range = 20
@export var ViewRange = 50
@export var ParticleColor : Color


@onready var Animator = AnimationPlayer.new()
@onready var NoiseE = FastNoiseLite.new()

var Target = null
var TargetPosition
var Targetcutoff
var deltacount = 0

func add_modifier(property, multiplier, duration):
	set(property, get("Max" + property) * multiplier)
	
	var timer = get_tree().create_timer(duration)
	await timer.timeout
	
	set(property, get("Max" + property))

func _ready():
	add_child(Animator)
	Animator.add_animation_library("",load("res://EnemyAnimations.tres"))

func move(pos : Vector2, resettarget = true):
	# round target position
	TargetPosition = Vector2(round(pos.x),round(pos.y))
	
	if resettarget:
		Targetcutoff = 1
		Target = null

func die():
	if $Texture:
		$Texture.queue_free()
		var CoolParticles = preload("res://death_particles.tscn").instantiate()
		CoolParticles.color = ParticleColor
		add_child(CoolParticles)
		CoolParticles.emitting = true
		await CoolParticles.finished
		queue_free()
	

func hit(damage, damager : BaseCulor):
	velocity -= position.direction_to(damager.position) * 10
	health -= damage
	if health <= 0:
		damager.TargetEnemy = null
		die()

func get_nearest_culor_in_range():
	var distance = 999
	var distanceholder = null
	for Culor in get_tree().get_nodes_in_group("Culorz"):
		if position.distance_to(Culor.position) <= ViewRange:
			if distance >= position.distance_to(Culor.position):
				distance = position.distance_to(Culor.position)
				distanceholder = Culor
	if distance == 999:
		return false
	else:
		return distanceholder
	
func _physics_process(delta):
	deltacount += delta
	if health <= 0:
		return
	
	# look for targets
	if Target == null:
		if get_nearest_culor_in_range():
			Target = get_nearest_culor_in_range()
		else:
			Target = null
	
	#set path to target
	if Target:
		move(Target.position,false)
		Targetcutoff = range
	
	#run all velos
	move_and_slide()
	
	# move towards target
	if TargetPosition and Target:
		if global_position.distance_to(TargetPosition) >= Targetcutoff:
			var direction = (TargetPosition - global_position).normalized()
			velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO,speed * delta)
	
	#attack target if possible
	if Target:
		if global_position.distance_to(Target.position) <= Targetcutoff:
			Animator.play("attack")
	else:
		velocity += Vector2(NoiseE.get_noise_1d(deltacount),NoiseE.get_noise_1d(deltacount + 30))
	
	

func AttackFromAnim():
	if Target != null:
		Target.hit(damage,self)
