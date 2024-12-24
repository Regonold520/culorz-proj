extends CanvasLayer

signal LeaveMixer()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(Globalactor.MixerItems)


func _on_button_pressed() -> void:
	if len(Globalactor.MixerItems) >= 2:
		for i in Globalactor.MixerItems:
			print(i.get_meta("Name"))

		var culor1 = Globalactor.assignedcolors[Globalactor.MixerItems[0].get_meta("Name")]
		var culor2 = Globalactor.assignedcolors[Globalactor.MixerItems[1].get_meta("Name")]
		
		var mixResult = Globalactor.mixcolors([culor1, culor2])
		
		print(mixResult)
		
		Globalactor.MixerMenu.find_child("Control").find_child("Culor3").texture = load("res://Culorz/" + mixResult[1].to_lower() + "_chr.png")
		
		Globalactor.culorinventory.append(mixResult[1])
		
		Globalactor.culorinventory.erase(Globalactor.MixerItems[0].get_meta("Name"))
		Globalactor.culorinventory.erase(Globalactor.MixerItems[1].get_meta("Name"))
		
		Globalactor.UpdateCulorDisplay()
		
		$Control/Button.disabled = true
		
		await get_tree().create_timer(1).timeout
		
		$Control/Button.disabled = false
		
		Globalactor.MixerMenu.find_child("Control").find_child("Culor1").texture = null
		Globalactor.MixerMenu.find_child("Control").find_child("Culor2").texture = null
		Globalactor.MixerMenu.find_child("Control").find_child("Culor3").texture = null
		
		Globalactor.MixerItems = []
		Globalactor.canDo2 = true
	

func _on_leave_pressed() -> void:
	LeaveMixer.emit()
