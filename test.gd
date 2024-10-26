extends CharacterBody2D


const speed = 30.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * speed

	move_and_slide()


func _on_mouse_entered():
	print("entered")


func _on_mouse_exited():
	print("exited")
