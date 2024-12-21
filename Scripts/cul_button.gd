extends Button

var isPressed = false

var culorName
var culorScene

var mixingIDX = 999
var textureStartPos

var isMixingButton = false

func _ready():
	textureStartPos = find_child("TextureRect").global_position

func _on_pressed():
	
	if !isMixingButton:
		if !isPressed and Globalactor.selectedCulorNode == null:
			Globalactor._set_culor(culorName, culorScene)
		elif isPressed and Globalactor.selectedCulorNode == culorScene:
			Globalactor._set_culor(null, null)
			
	if isMixingButton:
		if !isPressed:
			mixingIDX = get_parent().get_parent().get_parent()._add_culor(culorScene, find_child("TextureRect"))
			print(mixingIDX)
		elif isPressed and mixingIDX != 999:
			print("not", get_parent().get_parent().get_parent().name)
			get_parent().get_parent().get_parent()._remove_culor(culorScene, mixingIDX)
	
	isPressed = !isPressed
	
