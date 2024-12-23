extends CharacterBody2D
class_name BaseCulor
var isMouseHovering = false

var Mypersrandom # used for animations we dont want synced
var Timesincestart : float # time since start

@export var culor : Color
@export var speed = 40
@export var health = 20
@export var attackRange = 60
@export var attackCooldown = 2

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


func setupculor():
	#do technical stuff
	safe_margin = 0.001
	motion_mode = MotionMode.MOTION_MODE_FLOATING
	Mypersrandom = rng.randi_range(1 , 99) # used for animations we dont want synced
	
	#setup animator
	add_child(Animator)
	Animator.add_animation_library("",load("res://CulorAnimations.tres"))
	
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
		if position.distance_to(targetposition) >= targetcutoff:
			velocity = velocity.move_toward(targetposition - position,speed * delta)
		else:
			velocity = velocity.move_toward(Vector2.ZERO,speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO,speed * delta)
	move_and_slide()

func loopUntilRange():
	while position.distance_to(targetposition) >= targetcutoff:
		await get_tree().physics_frame
	return
	

func _physics_process(delta):
	#MOVE!!
	runmove(delta)
	velocity.move_toward(Vector2.DOWN,speed) * 34
	
	if !Animator.is_playing():
		if animoffset <= 0:
			Animator.play("idle")
		else:
			animoffset -= delta
	
	#visualize move with anim
	if Vector2(round(position.x * 10) / 10,round(position.y * 10)/ 10)  != lastpos:
		if !walkinganimstate:
			walkinganimstate = true
			Animator.play("walk")
	else:
		if walkinganimstate:
			walkinganimstate = false
			Animator.play("walkend",-1,1,true)
	
	if velocity.x != 0:
		if sign(velocity.x) == -1:
			$Texture.flip_h = true
		else:
			$Texture.flip_h = false
	
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
	targetcutoff = 0

func target(Enemy : BaseEnemy):
	move(Enemy.global_position)
	targetcutoff = attackRange
