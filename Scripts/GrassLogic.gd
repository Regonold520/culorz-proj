extends SupportCulor

var ring

func animation_hit():
	if Target != null:
		var allTargets = get_enemies()
		print(allTargets)
		if allTargets:
			for enemy : BaseEnemy in allTargets:
				enemy.add_modifier("speed" ,0.3 , 2.5)
				
			ring = Sprite2D.new()
			ring.texture = load("res://ring_slim.svg")
			
			
			ring.global_position = global_position
			ring.scale = Vector2(0,0)
			ring.modulate = culor
			
			get_tree().current_scene.add_child(ring)
			
			print("RING",ring)
			
			var tween = get_tree().create_tween()
			
			tween.tween_property(ring, "scale", Vector2(attackRange * 0.09488, attackRange * 0.09488), 0.3)
			
			await tween.finished
			
			print("FIN",ring)
			
			ring.queue_free()
