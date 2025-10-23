extends CharacterBody2D

var phase = 1
var health = 25
var player: CharacterBody2D
var attack: String = "wait"
var attacking = false

const top = Vector2(6785,-14850)
const bottom = Vector2(6785,-13665)
const left = Vector2(5575, -14270)
const right = Vector2(8000, -14270)
const center = Vector2(6785, -14270)

var can_attack = true

var can_be_damaged = false

const tornado_points = [
	left,
	bottom,
	right,
	top
]

@onready var music = get_parent().get_parent().get_node("Music")

func _ready():
	player = get_tree().get_root().get_node("Main/World/Bello")

func _physics_process(_delta):
	if Globals.playing:
		if not attacking:
			if attack == "":
				attack = "tornado"
			elif attack == "tornado":
				tornado(1000)
			elif attack == "rest":
				$RestTime.start()
				attacking = true
		else:
			if attack == "tornado":
				if $TornadoAttack.monitorable and can_attack:
					for body in $TornadoAttack.get_overlapping_bodies():
						if body.name == "Bello":
							body.health -= 50
							$TornadoCooldown.start()
							can_attack = false

func damage():
	if can_be_damaged:
		can_be_damaged = false
		$DamageCooldown.start()
		health -= 1
		if health <= 0:
			phase = 2
			health = 0
			attack = "wait"
			attacking = false
			$RestTime.stop()
			$TornadoCooldown.stop()
			$TornadoEnd.stop()
			jump_to(center)
			$DamageCooldown.stop()
			music.stop()
			music.stream = load("res://assets/music/EvilDevilPart2.mp3")
			music.play()

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
	
	$TornadoAttack.monitorable = true
	$TornadoAttack.monitoring = true
	await get_tree().process_frame
	await get_tree().process_frame
	for body in $TornadoAttack.get_overlapping_bodies():
		if body.name == "Bello":
			body.health -= 150
	$TornadoAttack.monitorable = false
	$TornadoAttack.monitoring = false
	
	$CollisionShape2D.disabled = false

func tornado(speed: float = 400.0):
	attacking = true
	await jump_to(top)
	
	$TornadoAttack.monitorable = true
	$TornadoAttack.monitoring = true
	
	for point in tornado_points:
		await move_to_point(point, speed)
	
	$TornadoAttack.monitorable = false
	$TornadoAttack.monitoring = false
	
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

func _on_tornado_cooldown_timeout() -> void:
	can_attack = true

func _on_damage_cooldown_timeout() -> void:
	can_be_damaged = true
