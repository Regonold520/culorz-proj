extends Camera2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Globalactor.selectedCulor != null:
		global_position.x += (Globalactor.selectedCulorNode.global_position.x - global_position.x) / 10
		global_position.y += (Globalactor.selectedCulorNode.global_position.y - global_position.y) / 10
		
