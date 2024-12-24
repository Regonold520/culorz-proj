extends Node


var Prisms = 10
var CurrentWave = 1

var tweenPos
var zoomPos
var culorinventory = []
var ShopMenu
var MixerMenu
var DeployMenu
var MixerItems = []
var ButtonsToCulors = {}
var UIPHASE = "Main"

var canDo2 = true

var rng = RandomNumberGenerator.new()

@onready var ButtonGroupE = ButtonGroup.new()

@onready var CulorDisplay = get_parent().get_child(1).find_child("CulorUI").find_child("Control").find_child("GridContainer")

func _process(delta: float) -> void:
	pass

func start():
	UIPHASE = "Shop"
	ShopMenu = preload("res://ShopUI.tscn").instantiate()
	get_parent().get_child(1).add_child(ShopMenu)
	ShopMenu.find_child("Control").find_child("Money").text = "Prisms: " + str(Prisms)
	ShopMenu.AttemptToBuyCulor.connect(AttemptedCulorPurchase)
	ShopMenu.LeaveShop.connect(mixer)
	
	UpdateCulorDisplay()
	
	
	if len(culorinventory) != 0:
		ShopMenu.find_child("Control").find_child("Leave").disabled = false

func mixer():
	UIPHASE = "Mixer"
	var NewTween = get_tree().create_tween()
	NewTween.tween_property(ShopMenu.find_child("Control"),"modulate", Color(0,0,0,0), 0.5)
	ShopMenu.find_child("Control").mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	
	MixerMenu = preload("res://MixerUI.tscn").instantiate()
	
	MixerMenu.LeaveMixer.connect(deployment)
	
	get_parent().get_child(1).add_child(MixerMenu)
	
func deployment():
	UIPHASE = "Deployment"
	var NewTween = get_tree().create_tween()
	
	NewTween.tween_property(MixerMenu.find_child("Control"),"modulate", Color(0,0,0,0), 0.5)
	
	MixerMenu.find_child("Control").mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	DeployMenu = preload("res://DeploymentUI.tscn").instantiate()
	
	DeployMenu.LeaveDeployment.connect(gameplayBegin)
	
	get_parent().get_child(1).add_child(DeployMenu)
	
	get_parent().get_child(1).find_child("WaveManager")._setup()
	
func gameplayBegin():
	UIPHASE = "Gameplay"
	
	var NewTween = get_tree().create_tween()
	
	NewTween.tween_property(DeployMenu.find_child("Control"),"modulate", Color(0,0,0,0), 0.5)
	NewTween.tween_property(get_tree().current_scene.find_child("CulorUI").find_child("ColorRect"),"modulate", Color(0,0,0,0), 0.5)
	

func CulorButtonPressThingamajig():
	var button = ButtonGroupE.get_pressed_button()
	
	if UIPHASE == "Deployment":
		var holder = get_parent().get_child(1).find_child("Culors")
		
		var newCulor = load("res://Culorz/" + button.get_meta("Name").to_lower() + ".tscn").instantiate()
		
		var randPos = Vector2(rng.randi_range(-48,48), rng.randi_range(27,63))
		
		newCulor.global_position = randPos
		
		holder.add_child(newCulor)
		
		button.disabled = true
	
	if UIPHASE == "Mixer":
		print("Mixing", button.get_meta("Name"))
		
		if len(MixerItems) < 2:
			MixerItems.append(button)
			button.disabled
			var GradientE : Gradient = MixerMenu.find_child("Gradient").texture.gradient
			
			
			if MixerItems[0]:
				
				GradientE.set_color(0, Color(assignedcolors[MixerItems[0].get_meta("Name")]) )
				if len(MixerItems) == 2:
					GradientE.set_color(1, Color(assignedcolors[MixerItems[1].get_meta("Name")]) )
		else:
			var NewSound = AudioStreamPlayer.new()
			NewSound.stream = preload("res://Error.mp3")
			add_child(NewSound)
			NewSound.play(0.3)
			
			
		if len(MixerItems) == 1:
			MixerMenu.find_child("Culor1").texture = load("res://Culorz/" + button.get_meta("Name").to_lower() + "_chr.png")
		if len(MixerItems) == 2 and canDo2:
			MixerMenu.find_child("Culor2").texture = load("res://Culorz/" + button.get_meta("Name").to_lower() + "_chr.png")
			canDo2 = false
			
func UpdateCulorDisplay():
	for Culor in CulorDisplay.get_children():
		Culor.queue_free()
	ButtonsToCulors = {}
	for Culor in culorinventory:
		var NewButton = load("res://SpecialScenes/CulorUIButton.tscn").instantiate()
		
		NewButton.icon = load("res://Culorz/" + Culor.to_lower() + "_chr.png")
		NewButton.set_meta("Name", Culor)
		CulorDisplay.add_child(NewButton)
		NewButton.pressed.connect(CulorButtonPressThingamajig)
		NewButton.button_group = ButtonGroupE
		ButtonsToCulors[NewButton] = Culor

func AttemptedCulorPurchase(Culor : String, Price : int):
	if Price <= Prisms:
		var NewSound = AudioStreamPlayer.new()
		NewSound.stream = preload("res://Purchase.mp3")
		add_child(NewSound)
		NewSound.play(1)
		
		Prisms -= Price
		culorinventory.append(Culor)
		
		ShopMenu.find_child("Control").find_child("Leave").disabled = false
		
	else:
		var NewSound = AudioStreamPlayer.new()
		NewSound.stream = preload("res://Error.mp3")
		add_child(NewSound)
		NewSound.play(0.3)
	ShopMenu.find_child("Control").find_child("Money").text = "Prisms: " + str(Prisms)
	UpdateCulorDisplay()

func get_selected_culors():
	if len(get_tree().get_nodes_in_group("Selected_Culor")) == 0:
		return false
	return get_tree().get_nodes_in_group("Selected_Culor")

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
	"Ninja": "000000",
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

	var currentcolor = Color(ColorsInQuestion[0])
	for i in ColorsInQuestion.size():

		var weirdorcolor = Color(ColorsInQuestion[i])
		weirdorcolor.a = 0.5
		currentcolor.a = 0.5
		currentcolor = weirdorcolor.blend(currentcolor)
		currentcolor.a = 1
	
	
	evaluatecolor(currentcolor)
	return [currentcolor, evaluatecolor(currentcolor)]
