extends CharacterBody2D
class_name BaseCulor
var isMouseHovering = false

var Mypersrandom
var Timesincestart : float

@export var culor : Color
@export var speed = 20
@export var health = 20
@export var range = 40


var rng = RandomNumberGenerator.new()
var targetposition : Vector2
var targetcutoff = 0

func _ready():
	safe_margin = 0.001
	Mypersrandom = rng.randi_range(1 , 99) # used for animations we dont want synced

func runmove():
	if targetposition:
		if position.distance_to(targetposition) >= targetcutoff:
			velocity.x = cos(position.angle_to_point(targetposition)) * speed
			velocity.y = sin(position.angle_to_point(targetposition)) * speed
	move_and_slide()
	velocity.x *= 0.9
	velocity.y *= 0.9

func _process(delta):
	#MOVE!!
	runmove()
	
	# run modulation animation for a selected culor
	Timesincestart += delta
	if is_in_group("Selected_Culor"):
		var animationvalue = 0.75+ (sin(Timesincestart * 5) * 0.25)
		modulate = Color(animationvalue,animationvalue,animationvalue)

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
	print("lesgo")

func target(Enemy : BaseEnemy):
	move(Enemy.global_position)
	targetcutoff = range
	print("GETOU-")
