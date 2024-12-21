extends Camera2D
class_name PlayerCamera

var DefCameraSpeed = 5
var wantedcampos = Vector2(0,0)
func _process(_delta):
	var CameraSpeed = DefCameraSpeed
	if Input.is_action_pressed("Left"):
		wantedcampos += Vector2(-1 * CameraSpeed,0)
	if Input.is_action_pressed("Right"):
		wantedcampos += Vector2(CameraSpeed,0)
	if Input.is_action_pressed("Up"):
		wantedcampos += Vector2(0,-1 * CameraSpeed)
	if Input.is_action_pressed("Down"):
		wantedcampos += Vector2(0,CameraSpeed)
	
	wantedcampos.x -= checkbound(wantedcampos.x,-245)
	wantedcampos.x -= checkbound(wantedcampos.x,245)
	wantedcampos.y -= checkbound(wantedcampos.y,-125)
	wantedcampos.y -= checkbound(wantedcampos.y,125)
	global_position += ((wantedcampos - global_position) / 10)



func checkbound(value,limit):
	#print("if ",value * sign(limit)," is greater than or equal too ", abs(limit))
	if value * sign(limit) >= abs(limit):
		var change = abs(limit) - (value * sign(limit))
		#print("distance to border ", change)
		return (change / 20) * sign(limit) * -1
	return 0
