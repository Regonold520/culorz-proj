extends Node

var Crosshairs = []
var CrosshairScene = preload("res://SpecialScenes/cross_hair.tscn").instantiate()

@onready var RNG = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _setup():
	var Wave = Globalactor.CurrentWave
	var Enemies = RNG.randf_range(Wave,floor(Wave * 1.5))
	
	for E in range(Enemies):
		var NewCrosshair = CrosshairScene.duplicate()
		NewCrosshair.position.x = RNG.randf_range(-102,102)
		NewCrosshair.position.y = RNG.randf_range(20,88)
		add_child(NewCrosshair)
		Crosshairs.append(NewCrosshair)

func _start_wave():
	var enemies = ["res://Enemies/blob.tscn","res://Enemies/droplet.tscn","res://Enemies/knife.tscn"]
	for E in Crosshairs:
		var NewEnemy : CharacterBody2D = load(enemies.pick_random()).instantiate() 
		NewEnemy.position = E.position
		$"../Threats".add_child(NewEnemy)
		var NewTween = get_tree().create_tween()
		NewEnemy.modulate = Color(0,0,0,0)
		NewEnemy.process_mode = Node.PROCESS_MODE_DISABLED
		NewTween.tween_property(NewEnemy,"modulate", Color(1,1,1,1), 1)
		await NewTween.finished
		NewTween = get_tree().create_tween()
		NewTween.tween_property(E,"modulate", Color(1,1,1,0), 1)
		NewEnemy.process_mode = Node.PROCESS_MODE_ALWAYS
		NewEnemy.connect("Died",EnemyDied)
		
	Crosshairs.clear()
	for E : BaseCulor in $"../Culors".get_children():
		E.Died.connect(CulorDied)
		

func EnemyDied():
	await get_tree().physics_frame
	print($"../Threats".get_child_count())
	if $"../Threats".get_child_count() == 0:
		Globalactor.culorinventory.clear()
		for E in $"../Culors".get_children():
			Globalactor.culorinventory.append(E.get_meta("Type"))
			E.queue_free()
		Globalactor.Prisms += RNG.randi_range(Globalactor.CurrentWave, Globalactor.CurrentWave * 2)
		Globalactor.CurrentWave += 1
		Globalactor.start()

func CulorDied():
	await get_tree().physics_frame
	if $"../Culors".get_child_count() == 1:
		for E in $"../Culors".get_children():
			E.queue_free()
		for E in $"../Threats".get_children():
			E.queue_free()
		Globalactor.Prisms = 10
		Globalactor.CurrentWave = 1
		var NewTween = get_tree().create_tween()
		NewTween.tween_property($"../MainMenu".find_child("Control"), "modulate", Color(1,1,1,1), 1)
		NewTween.parallel().tween_property(get_tree().current_scene.find_child("CulorUI").find_child("ColorRect"),"modulate", Color(1,1,1,1), 0.5)
		$"../AudioStreamPlayer".TransitionTo("Culorz Theme")
		$"../MainMenu".find_child("Control").mouse_filter = Control.MOUSE_FILTER_STOP
		
