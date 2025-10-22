extends Button

var touching_mouse = false
var x: float
var y: float
var origin_scale: float

var speed: float

var shake_strenght: int = 2
var big_strenght: float = 1.1

func _ready():
	x = position.x
	y = position.y
	origin_scale = scale.x
	pivot_offset = size / 2


func _process(_delta):
	if touching_mouse:
		position.x = x + randf_range(-shake_strenght, shake_strenght)
		position.y = y + randf_range(-shake_strenght, shake_strenght)
		bounce(big_strenght, 0.002)
	else:
		position = Vector2(x, y)
		bounce(origin_scale, -0.002)

func _on_mouse_entered():
	touching_mouse = true

func _on_mouse_exited():
	touching_mouse = false

func bounce(target_size, force):
	speed = speed * 0.9 + force
	scale.x += speed
	scale.y += speed
	if (scale.x > target_size) == (force > 0):
		scale.x = target_size
		scale.y = target_size
		speed = -0.8 * speed
		if abs(speed) < 4:
			speed = 0
