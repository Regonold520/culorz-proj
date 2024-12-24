extends CanvasLayer

signal AttemptToBuyCulor(Culor : String, Price : int)
signal LeaveShop()
var RandomCulor

func _on_yellow_button_pressed():
	AttemptToBuyCulor.emit("Dancer",1)
func _on_red_button_pressed():
	AttemptToBuyCulor.emit("Boxer",1)
func _on_blue_button_pressed():
	AttemptToBuyCulor.emit("Spear",1)

func _ready():
	RandomCulor = Globalactor.assignedcolors.keys().pick_random()
	var newtexture = load("res://Culorz/" + RandomCulor.to_lower() + "_chr.png")
	$Control/RandomCulor.texture = newtexture

func _on_random_button_pressed():
	AttemptToBuyCulor.emit(RandomCulor,5)


func _on_button_pressed():
	LeaveShop.emit()
