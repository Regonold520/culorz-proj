extends CharacterBody2D
class_name BaseCulor
var isMouseHovering = false

var Mypersrandom # used for animations we dont want synced
var Timesincestart : float # time since start

@export var culor : Color
@export var speed = 40
@export var health = 20
@export var attackRange = 60
@export var attackSpeed = 1.0

var attackTimer = Timer.new()

var rng = RandomNumberGenerator.new()
var targetposition : Vector2

var targetcutoff = 0
var walkinganimstate = false
var lastpos = Vector2(0,0)
var animoffset = 0

@onready var Animator = AnimationPlayer.new()

func _ready():
	setupculor()

func die():
	if $Texture:
		$Texture.queue_free()
		var CoolParticles = preload("res://death_particles.tscn").instantiate()
		CoolParticles.color = culor
		add_child(CoolParticles)
		CoolParticles.emitting = true
		await CoolParticles.finished
		queue_free()

func hit(damage, damager : BaseEnemy):
	velocity -= position.direction_to(damager.position) * 10
	health -= damage
	if health <= 0:
		damager.Target = null
		die()

func setupculor():
	var newArea : Area2D = Area2D.new()
	var newShape = find_child("CollisionShape2D").duplicate()
	
	newArea.priority = 1
	
	add_child(newArea)
	newArea.add_child(newShape)
	
	#do technical stuff
	safe_margin = 0.001
	motion_mode = MotionMode.MOTION_MODE_FLOATING
	Mypersrandom = rng.randi_range(1 , 99) # used for animations we dont want synced
	
	#setup animator
	add_child(Animator)
	Animator.add_animation_library("",load("res://CulorAnimations.tres"))
	Animator.speed_scale = attackSpeed
	
	#setup attack timer
	add_child(attackTimer)
	
	#if a extended has ready
	if has_method("ready2"):
		call("ready2")
	
	#add to culorz
	add_to_group("Culorz")
	
	#set offset to first idle
	
	animoffset = rng.randf_range(1,2)

func runmove(delta):
	if targetposition:
		if global_position.distance_to(targetposition) >= targetcutoff:
			var direction = (targetposition - global_position).normalized()
			velocity = direction * speed
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO,delta * (0.25 * 50))
	if global_position.distance_to(targetposition) <= targetcutoff:
		velocity = Vector2()
		  # Stop moving

func loopUntilRange():
	while position.distance_to(targetposition) >= targetcutoff:
		await get_tree().physics_frame
	return
	

func _physics_process(delta):
	if health <= 0:
		return
	#MOVE!!
	runmove(delta)
	
	if !Animator.is_playing():
		if animoffset <= 0:
			Animator.play("idle")
		else:
			animoffset -= delta
	
	#visualize move with anim
	if Vector2(round(position.x * 10) / 10,round(position.y * 10)/ 10)  != lastpos:
		if !walkinganimstate:
			walkinganimstate = true
			#Animator.play("walk")
	else:
		if walkinganimstate:
			walkinganimstate = false
			#Animator.play("walkend",-1,1,true)
	
	if velocity.x != 0:
		if sign(velocity.x) == -1:
			$Texture.scale.x = -1
			
		else:
			$Texture.scale.x = 1
	
	# run modulation animation for a selected culor
	Timesincestart += delta
	if is_in_group("Selected_Culor"):
		var animationvalue = 0.75+ (sin(Timesincestart * 5) * 0.25)
		modulate = Color(animationvalue,animationvalue,animationvalue)
	lastpos.x = round(position.x * 10) / 10
	lastpos.y = round(position.y * 10) / 10

func select():
	if not is_in_group("Selected_Culor"):
		add_to_group("Selected_Culor")

func deselect():
	if is_in_group("Selected_Culor"):
		remove_from_group("Selected_Culor")
		#reset modulation animation
		modulate = Color(1,1,1)

func move(pos : Vector2):
	targetposition = Vector2(round(pos.x),round(pos.y))
	targetcutoff = 1

func target(Enemy : BaseEnemy):
	move(Enemy.global_position)
	targetcutoff = attackRange
