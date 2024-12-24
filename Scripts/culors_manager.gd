extends Node2D

var ringtexture = preload("res://ring.svg")
var canrally = true
var selected_area : Area2D = null
var selected_area_prio = 0
@onready var RallyCooldownTimer = $RallyCooldown
@onready var MoveArea = $"../MoveArea"
@onready var Selector = $SelectorArea



func _input(event):
	if event is InputEventMouseButton:
		# Left Click -> Rally
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed == true:
				if canrally and Globalactor.UIPHASE == "Gameplay":
					rally(get_global_mouse_position(),25)
		
		# Right Click -> Move
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed == true:
				process_select(get_global_mouse_position())


func process_select(pos):
	#Move
	Selector.global_position = Vector2(round(pos.x),round(pos.y))
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	# We reset selection
	selected_area_prio = -20
	selected_area = null
	
	for AreaInQuestion : Area2D in Selector.get_overlapping_areas():
		if AreaInQuestion.priority > selected_area_prio:
			selected_area = AreaInQuestion
			selected_area_prio = AreaInQuestion.priority
	
	if selected_area:
		print(selected_area.get_parent())
		if selected_area.get_parent() is BaseEnemy:
			if Globalactor.get_selected_culors():
				for Culor : BaseCulor in Globalactor.get_selected_culors():
					if "friendlyTarget" in Culor and !Culor.friendlyTarget:
						Culor.target(selected_area.get_parent())
					elif "friendlyTarget" not in Culor:
						Culor.target(selected_area.get_parent())
			return
		if selected_area.get_parent() is BaseCulor:
			if Globalactor.get_selected_culors():
				for Culor : BaseCulor in Globalactor.get_selected_culors():
					if "friendlyTarget" in Culor and Culor.friendlyTarget:
						Culor.target(selected_area.get_parent())
			return
		if selected_area == MoveArea:
			if Globalactor.get_selected_culors():
				for Culor : BaseCulor in Globalactor.get_selected_culors():
					Culor.move(pos)

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
