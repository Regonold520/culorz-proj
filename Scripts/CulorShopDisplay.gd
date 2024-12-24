extends Sprite2D
var deltacount = 0
@onready var rng = RandomNumberGenerator.new()
func _ready():
	deltacount += rng.randf_range(1,100)
func _process(delta):
	deltacount += delta
	#skew = sin(deltacount * 2) * 0.5
	offset.x = sin(deltacount * 2) * 0.5
	offset.y = cos((deltacount + 50) * 1) * 0.5
	rotation = cos(deltacount + 86) * deg_to_rad(10)
