extends Control

var ammountMixing = 0
var culorsMixingScenes = []
var culorz = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _add_culor(Scene ,textueScene):
	ammountMixing += 1
	print(Scene.culor)
	
	var tween = create_tween()
	
	textueScene.position = Vector2(0,0)
	Scene.reparent(find_child("POS" + str(ammountMixing)))
	
	culorsMixingScenes.append(Scene)
	culorz.append(Scene.culor)
	
	return ammountMixing - 1
	
func _remove_culor(Scene, idx):
	ammountMixing -= 1
	
	var tween = create_tween()
	
	culorsMixingScenes.erase(Scene)
	culorz.erase(Scene.culor)
