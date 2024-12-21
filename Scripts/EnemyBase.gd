extends CharacterBody2D
class_name BaseEnemy

@export var speed = 20
@export var health = 20

func _ready():
	#incase the enemy doesnt have a area2d
	if not find_child("Area2D"):
		var New2D = Area2D.new()
		add_child(New2D)
		var NewCol = $CollisionShape2D.duplicate()
		New2D.add_child(NewCol)
	
	find_child("Area2D").collision_layer = 2
