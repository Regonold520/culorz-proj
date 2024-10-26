extends Node

var selectedCulor = null
var selectedCulorNode = null

var tweenPos
var zoomPos

func _set_culor(culorName, culorNode):
	var cam = get_tree().current_scene.find_child("Camera2D")
	tweenPos = create_tween()
	tweenPos.set_trans(Tween.TRANS_CIRC)
	
	zoomPos = create_tween()
	zoomPos.set_trans(Tween.TRANS_CIRC)
	
	selectedCulor = culorName
	selectedCulorNode = culorNode

	if culorNode != null:
		tweenPos.tween_property(cam, "global_position", culorNode.global_position, 0.25)
		zoomPos.tween_property(cam, "zoom", Vector2(4.215, 4.215), 0.25)
	elif culorNode == null:
		tweenPos.tween_property(cam, "global_position", Vector2(0,0), 0.25)
		zoomPos.tween_property(cam, "zoom", Vector2(3.215, 3.215), 0.25)
		

func _idle_logic(timer, tex, randomOffset, multiplier):
	var Cosi = cos(timer + randomOffset)
	
	var TextureHeight = tex.texture.get_height()
	
	return Cosi * (TextureHeight / multiplier)
	
	
var assignedcolors = {
	"Boxer":"ac3232",
	"Star":"B8412F",
	"Bow":"C34F2C",
	"Fire":"D16029",
	"Pirate":"DF7126",
	"Wizard":"DF8226",
	"Mage":"DF9326",
	"Folder":"EDC22E",
	"Dancer":"FBF236",
	"Potion":"CAEB43",
	"Nunchucks":"99E550",
	"Grass":"81D140",
	"Pistol":"6ABE30",
	"Minigun":"64D181",
	"Sniper":"5FE4D3",
	"Bubble":"61BFE9",
	"Spear":"639BFF",
	"Shield":"8280DC",
	"Axe":"A265B9",
	"Scythe":"8C53A1",
	"Mace":"76428A",
	"Hammer":"913A87",
	"Bomb":"AC3284",
	"Heart":"AC325B",
	"Sun":"FFFFFF",
	"Rock":"696A6A",
	"Moon": "000000",
	"Choco":"8F563B",
}


func evaluatecolor(ncolor):
	var bestdistance = 100000000

	var bestmatch = 0
	for e in assignedcolors:
		var ColorToUsable = Color(assignedcolors[e], 1)
		var Distance = color_distance(ColorToUsable,ncolor, true)

		if Distance < bestdistance:
			bestdistance = Distance
			bestmatch = e
	
	return bestmatch

func color_distance(color1: Color, color2: Color, type : bool) -> float:
	if type:
		var r_diff = color1.r - color2.r
		var g_diff = color1.g - color2.g
		var b_diff = color1.b - color2.b
		return sqrt(r_diff * r_diff + g_diff * g_diff + b_diff * b_diff)
	else:
		var Color1V = Vector3(color1.r,color1.g,color1.b)
		var Color2V = Vector3(color2.r,color2.g,color2.b)
		return Color1V.distance_to(Color2V)

func mixcolors(ColorsInQuestion : Array):

	var currentcolor = ColorsInQuestion[0]
	for i in ColorsInQuestion.size():

		var weirdorcolor = Color(ColorsInQuestion[i])
		weirdorcolor.a = 0.5
		currentcolor.a = 0.5
		currentcolor = ColorsInQuestion[i].blend(currentcolor)
		currentcolor.a = 1
	
	
	evaluatecolor(currentcolor)
	return [currentcolor, evaluatecolor(currentcolor)]
