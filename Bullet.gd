extends RigidBody2D
class_name Bullet

@export var Movespeed = 10
@export var Pierce = false
@export var expiration = 10
@export var HitSound = AudioStream.new()

var Shooter = null
var Damage = 10
var hitenemies = []

func _ready() -> void:
	await get_tree().create_timer(expiration).timeout
	queue_free()

func _on_area_2d_area_entered(area):
	if area.get_parent():
		if area.get_parent() is BaseEnemy:
			if !hitenemies.has(area):
				hitenemies.append(area)
				if area.get_parent().has_method("hit"):
					if area.get_parent() != null:
						area.get_parent().hit(Damage,Shooter)
						if !Pierce:
							var NewAudio = AudioStreamPlayer2D.new()
							get_tree().current_scene.add_child(NewAudio)
							NewAudio.pitch_scale = randf_range(0.9,1.1)
							NewAudio.stream = HitSound
							NewAudio.playing = true
							
							queue_free()
