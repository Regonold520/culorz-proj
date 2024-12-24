extends SupportCulor

var ring

func animation_hit():
	if Target != null:
		var allTargets = get_culorz()
		print(allTargets)
		if allTargets:
			for culor : BaseCulor in allTargets:
				culor.add_modifier("damage" ,1.3 , 2)
				
			ring = Sprite2D.new()
			ring.texture = load("res://ring_slim.svg")
			
			
			ring.global_position = global_position
			ring.scale = Vector2(0,0)
			ring.modulate = culor
			
			get_tree().current_scene.add_child(ring)
			
			print("RING",ring)
			
			var tween = get_tree().create_tween()
			
			tween.tween_property(ring, "scale", Vector2(attackRange * 0.09488, attackRange * 0.09488), attackSpeed - 0.75)
			
			print("SIGMA",ring)
			
			await tween.finished
		
			
			if not ring == null:
				ring.queue_free()
