extends CharacterBody2D

var isMouseHovering = false

var Mypersrandom
var Timesincestart : float

@export var culor : Color

var speed = 60

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Mypersrandom = rng.randi_range(1 , 99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Timesincestart += delta 
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT) and Globalactor.selectedCulor == name:
		Globalactor._set_culor(null, null)
		
	if Input.is_action_just_pressed("Select") and Globalactor.selectedCulor == null and isMouseHovering:
		Globalactor._set_culor(name, self)
		
	if Globalactor.selectedCulor == name:
		var direction = Input.get_vector("Left", "Right", "Up", "Down")
		
		velocity = direction * speed
		
		move_and_slide()
			
		if !Input.is_action_pressed("Right") and !Input.is_action_pressed("Left") and !Input.is_action_pressed("Up") and !Input.is_action_pressed("Down"):
			velocity = Vector2.ZERO
		
		if velocity.x < 0:
			$Texture.flip_h = true
		elif velocity.x > 0:
			$Texture.flip_h = false
	else:
		velocity = Vector2.ZERO
		
	if velocity != Vector2(0, 0):
		var Timetrue = Timesincestart
		Timetrue *= 10
		var Cosi = cos(Timetrue)
		Cosi *= 2
		var Final = abs(Cosi) - 2
		$Texture.offset.y = Final 
		
		$Texture.rotation_degrees = Cosi
		
	else:
		Timesincestart = 0
		$Texture.offset.y = 0
		$Texture.rotation = 0
		
	

func _on_mouse_entered():
	isMouseHovering = true


func _on_mouse_exited():
	isMouseHovering = false
