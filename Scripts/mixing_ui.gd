extends Control

var ammountMixing = 0
var culorsMixingScenes = []
var culorz = []

func _add_culor(Scene ,textueScene):
	ammountMixing += 1
	print(Scene.culor)
	
	textueScene.position = Vector2(0,0)
	Scene.reparent(find_child("POS" + str(ammountMixing)))
	
	culorsMixingScenes.append(Scene)
	culorz.append(Scene.culor)
	
	return ammountMixing - 1
	
func _remove_culor(Scene, _idx):
	ammountMixing -= 1
	
	
	culorsMixingScenes.erase(Scene)
	culorz.erase(Scene.culor)
