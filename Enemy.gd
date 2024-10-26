extends Control

var timer = 0.0
var randOffset = 0

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	randOffset = rng.randi_range(1, 99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	$Sprite2D.offset.y = Globalactor._idle_logic(timer, $Sprite2D, randOffset, 5)
	
