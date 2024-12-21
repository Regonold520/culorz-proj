extends Node2D

var ringtexture = preload("res://ring.svg")
var canrally = true
var selected_area : Area2D = null
@onready var RallyCooldownTimer = $RallyCooldown
@onready var MoveArea = $"../MoveArea"

func _input(event):
	if event is InputEventMouseButton:
		# Left Click -> Rally
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed == true:
				if canrally:
					rally(get_global_mouse_position(),25)
		
		# Right Click -> Move
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed == true:
				process_select(get_global_mouse_position())

func process_select(pos):
	# Create Area2D we use to check overlapping
	var NewArea = Area2D.new()
	var NewBox = CollisionShape2D.new()
	NewBox.shape = CircleShape2D.new()
	NewArea.add_child(NewBox)
	selected_area = null
	add_child(NewArea)
	# Connect area to a function
	NewArea.connect("area_entered",selectGetTouching)
	
	#We set the collision mask to be bit 2, that way enemies get processed first.
	NewArea.collision_mask = 0b0010
	# Move area to position, forcing the area_entered to get fired
	NewArea.position = pos
	await [NewArea.area_entered, await get_tree().create_timer(0.05).timeout]
	if selected_area:
		if selected_area.get_parent() is BaseEnemy:
			if Globalactor.get_selected_culors():
				for Culor : BaseCulor in Globalactor.get_selected_culors():
					Culor.target(selected_area.get_parent())
			return
	
	
	
	#We set the collision mask to be bit 1, so then its movement
	NewArea.collision_mask = 0b0001
	# Move area to position, forcing the area_entered to get fired
	NewArea.position = pos
	await [NewArea.area_entered, await get_tree().create_timer(0.05).timeout]
	if selected_area == MoveArea:
		
		if Globalactor.get_selected_culors():
			for Culor : BaseCulor in Globalactor.get_selected_culors():
				Culor.move(pos)
	

func selectGetTouching(toucher):
	selected_area = toucher

func rally(pos,distance):
	#start cooldown
	canrally = false
	RallyCooldownTimer.start()
	
	#deselct previous culors
	if Globalactor.get_selected_culors():
		for Culor : BaseCulor in Globalactor.get_selected_culors():
			Culor.deselect()
	
	
	# get culors in area and select them
	for Culor : BaseCulor in $"../Culors".get_children():
		if Culor.position.distance_to(pos) <= distance:
			Culor.select()
	
	# create the ring
	var NewRing = Sprite2D.new()
	NewRing.position = pos
	NewRing.scale.x = distance * 0.09488
	NewRing.scale.y = distance * 0.09488
	NewRing.texture = ringtexture
	add_child(NewRing)
	
	#tween the dissapearing animation
	var newtween = create_tween()
	newtween.set_trans(Tween.TRANS_EXPO)
	newtween.tween_property(NewRing, "modulate", Color.TRANSPARENT, 1)
	newtween.parallel().tween_property(NewRing, "scale", Vector2(0,0), 1)
	newtween.tween_callback(NewRing.queue_free)
func allowrally():
	#when the timer ends, we need to re-allow player to rally
	canrally = true
