extends Node2D

var can_attack = true

const top = Vector2(6785,-14850)
const bottom = Vector2(6785,-13665)
const left = Vector2(5575, -14270)
const right = Vector2(8000, -14270)

const tornado_points = [
	left,
	bottom,
	right,
	top
]

var sword_dir = Vector2.RIGHT
var sword_rotation_speed = 20

func _ready():
	await tornado(1200)
	await tornado(1200)
	await tornado(1200)
	queue_free()

func _process(delta: float) -> void:
	
	sword_dir = sword_dir.rotated(sword_rotation_speed * delta)
	global_rotation = sword_dir.angle()
	
	for child in get_children():
		if "Sword" in child.name:
			var area: Area2D = child.get_node("Area2D")
			for body in area.get_overlapping_bodies():
				if body.name == "Bello":
					if can_attack:
						body.health -= 60
						can_attack = false
						$AttackCooldown.start()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func move_to_point(target: Vector2, speed: float):
	while global_position.distance_to(target) > 10:
		var direction = (target - global_position).normalized()
		global_position += direction * speed * get_process_delta_time()
		await get_tree().process_frame
		
func tornado(speed: float = 400.0):
	
	global_position = top
	
	for point in tornado_points:
		await move_to_point(point, speed)
