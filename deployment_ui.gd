extends CanvasLayer

signal LeaveDeployment()



func _on_button_pressed() -> void:
	LeaveDeployment.emit()
