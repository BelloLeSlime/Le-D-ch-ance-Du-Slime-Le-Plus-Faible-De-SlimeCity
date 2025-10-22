extends CharacterBody2D

var phase = 1
var health = 25
var player: CharacterBody2D
var attack: String = "wait"
var attacking = false

const top = Vector2(3605,-370)
const bottom = Vector2(3823,845)
const left = Vector2(2728, 112)
const right = Vector2(4568, 112)
const center = Vector2(3625, 112)

const tornado_points = [
	left,
	bottom,
	right,
	top
]


func _ready():
	player = get_tree().get_root().get_node("Main/Level3/Bello")

func _physics_process(_delta):
	
	if not attacking:
		if attack == "":
			attack = "tornado"
		elif attack == "tornado":
			tornado(1000)
		elif attack == "rest":
			$RestTime.start()
			attacking = true
		

func damage():
	health -= 1
	if health <= 0:
		phase = 2

func jump_to(target_position: Vector2):
	
	$CollisionShape2D.disabled = true

	var jump_height := -3000
	var up_duration := 1
	var down_duration := 1

	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y + jump_height, up_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished

	global_position.x = target_position.x

	var tween_down = create_tween()
	tween_down.tween_property(self, "position:y", target_position.y, down_duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	
	await tween_down.finished

	$CollisionShape2D.disabled = false

func tornado(speed: float = 400.0):
	attacking = true
	await jump_to(top)
	
	for point in tornado_points:
		await move_to_point(point, speed)
	
	$TornadoEnd.start()
	await $TornadoEnd.timeout
	
	await jump_to(center)
	
	attack = "rest"
	attacking = false
	

func move_to_point(target: Vector2, speed: float):
	while global_position.distance_to(target) > 10:
		var direction = (target - global_position).normalized()
		global_position += direction * speed * get_process_delta_time()
		await get_tree().process_frame

func _on_rest_time_timeout() -> void:
	attack = ""
	attacking = false
