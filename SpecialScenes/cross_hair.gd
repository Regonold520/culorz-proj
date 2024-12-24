extends Node2D
var deltacount = 0
func _process(delta):
	deltacount += delta
	$Sprite2D.rotation = deltacount
