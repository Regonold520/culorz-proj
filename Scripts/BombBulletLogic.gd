extends Bullet
class_name ExplosiveBullet

@export var ExplosionSize = 20

func get_enemies():
	var distance = 999
	var distanceholder = []
	for Culor in get_tree().get_nodes_in_group("Enemies"):
		if position.distance_to(Culor.position) <= ExplosionSize:
			distanceholder.append(Culor)
			distance = 0
	if distance == 999:
		return false
	else:
		return distanceholder

func _on_area_2d_area_entered(area):
	if area.get_parent():
		if area.get_parent() is BaseEnemy:
			if !hitenemies.has(area):
				hitenemies.append(area)
				if area.get_parent().has_method("hit"):
					if area.get_parent() != null:
						var Enemies = get_enemies()
						for I : BaseEnemy in Enemies:
							I.hit(Damage, Shooter)
						var ring = Sprite2D.new()
						ring.texture = load("res://ring_slim.svg")
						
						
						ring.global_position = global_position
						ring.scale = Vector2(0,0)
						ring.modulate = Shooter.culor
						
						get_tree().current_scene.add_child(ring)
						
						print("RING",ring)
						
						var tween = get_tree().create_tween()
						
						var NewAudio = AudioStreamPlayer2D.new()
						get_tree().current_scene.add_child(NewAudio)
						NewAudio.pitch_scale = randf_range(0.9,1.1)
						NewAudio.stream = HitSound
						NewAudio.playing = true
						tween.tween_property(ring, "scale", Vector2(ExplosionSize * 0.09488, ExplosionSize * 0.09488), 0.5)
						tween.tween_property(ring, "modulate", Color(0,0,0,0),1)
						$Pistol.visible = false
						
						await tween.finished
						if not ring == null:
							ring.queue_free()
						
