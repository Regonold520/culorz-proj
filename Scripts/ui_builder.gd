extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	_build_culor_buttons()

func _build_culor_buttons():
	for i in $"../../../Culors".get_children():
		print(i)
		var buttonScene = load("res://cul_button.tscn")
		
		var button = buttonScene.instantiate()
		var MixingButton = buttonScene.instantiate()
		
		button.find_child("TextureRect").texture = i.find_child("Texture").texture
		button.find_child("Boarder").modulate = i.culor
		
		MixingButton.find_child("TextureRect").texture = i.find_child("Texture").texture
		MixingButton.find_child("Boarder").modulate = i.culor
		
		button.culorName = i.name
		button.culorScene = i
		
		MixingButton.culorName = i.name
		MixingButton.culorScene = i
		MixingButton.isMixingButton = true
		
		$"../CulHolder".add_child(button)
		$"../MixingUI/BG2/GridContainer".add_child(MixingButton)
