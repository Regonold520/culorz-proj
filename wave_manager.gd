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
