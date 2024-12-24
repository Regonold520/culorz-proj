extends Button
func _on_pressed():
	print("hi")
	Globalactor.start()
	var AnimationTween = get_tree().create_tween()
	AnimationTween.tween_property($"..","modulate", Color(0,0,0,0), 0.5)
	$"..".mouse_filter = Control.MOUSE_FILTER_IGNORE
