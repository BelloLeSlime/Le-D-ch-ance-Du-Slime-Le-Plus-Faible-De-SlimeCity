extends CharacterBody2D

signal attack_finished

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

var tornadoing = false

const tornado_points = [
	left,
	bottom,
	right,
	top
]

const jump_random_ponts = [
	top,
	bottom,
	right,
	left,
	center
]

const attacks_phase_2 = [
	"mega_tornado",
	"mega_tornado",
	"jump_random",
	"jump_random",
	"jump_random",
	"explosion",
	"explosion",
	"rest",
	"rest",
	"enemies",
	"enemies",
	"laser",
	"laser",
]

@onready var music = get_parent().get_parent().get_node("Music")

@onready var origin_pos_sword = $Sword.position
@onready var origin_rot_sword = $Sword.rotation
@onready var sword = $Sword
var sword_dir = Vector2.RIGHT
var sword_radius = 50
var sword_rotation_speed = 10 # radians/sec

var mega_tornado_preload = preload("res://scenes/megatornado.tscn")
var mega_tornado: Node2D

var explosion_preload = preload("res://scenes/explosion.tscn")

var melee_preload = preload("res://scenes/melee_enemy.tscn")
var ranger_preload = preload("res://scenes/ranger_enemy.tscn")
var mage_preload = preload("res://scenes/mage_enemy.tscn")
var tank_preload = preload("res://scenes/tank_enemy.tscn")
var protector_preload = preload("res://scenes/protector_enemy.tscn")

var enemies = [
	melee_preload,
	ranger_preload,
	mage_preload,
	tank_preload,
	protector_preload
]

var laser_preload = preload("res://scenes/laser.tscn")

func _ready():
	player = get_tree().get_root().get_node("Main/World/Bello")
	$AnimatedSprite2D.play("walk")

func _physics_process(delta):
	if Globals.playing:
		if phase == 1:
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
					if tornadoing:
						sword_dir = sword_dir.rotated(sword_rotation_speed * delta)
						sword.position = sword_dir * sword_radius
						sword.rotation = sword_dir.angle()
					else:
						sword.position = origin_pos_sword
						sword.rotation = origin_rot_sword
					if $Sword/TornadoAttack.monitorable and can_attack:
						for body in $Sword/TornadoAttack.get_overlapping_bodies():
							if body.name == "Bello":
								body.health -= 50
								$TornadoCooldown.start()
								can_attack = false
		elif phase == 2:
			if not attacking:
				if attack == "":
					attack = attacks_phase_2.pick_random()
				elif attack == "mega_tornado":
					mega_tornado = mega_tornado_preload.instantiate()
					get_tree().get_root().get_node("Main/World").add_child(mega_tornado)
					attacking = true
					$AttackCooldown.wait_time = randf_range(0.5,1.0)
					$AttackCooldown.start()
				elif attack == "jump_random":
					var destination = jump_random_ponts.pick_random()
					attacking = true
					await jump_to(destination)
					$AttackCooldown.wait_time = randf_range(0.5,1.0)
					$AttackCooldown.start()
				elif attack == "explosion":
					attacking = true
					explosion(int(randf_range(2, 10)))
					$AttackCooldown.wait_time = randf_range(0.5,1.0)
					$AttackCooldown.start()
				elif attack == "rest":
					attacking = true
					$RestTime.start()
				elif attack == "enemies":
					attacking = true
					for point in jump_random_ponts:
						var enemy_preload = enemies.pick_random()
						var enemy = enemy_preload.instantiate()
						get_parent().add_child(enemy)
						enemy.position = point
					$AttackCooldown.wait_time = randf_range(0.5,1.0)
					$AttackCooldown.start()
				elif attack == "laser":
					attacking = true
					var laser = laser_preload.instantiate()
					get_parent().add_child(laser)
					$AttackCooldown.wait_time = randf_range(0.5,1.0)
					$AttackCooldown.start()
					
					

func explosion(amount: int):
	for _i in range(amount):
		var explosion_item = explosion_preload.instantiate()
		get_parent().add_child(explosion_item)
		$ExplosionCooldown.start()
		await $ExplosionCooldown.timeout

func damage():
	if can_be_damaged:
		can_be_damaged = false
		$DamageCooldown.start()
		health -= 1
		if health <= 0 and phase == 1:
			phase = 2
			health = 0
			$RestTime.stop()
			$TornadoCooldown.stop()
			$DamageCooldown.stop()
			attacking = false
			if attacking and attack == "tornado":
				await attack_finished
			attack = "wait"
			
			music.stop()
			
			var cutscene = get_parent().get_node("Cutscene")
			cutscene.visible = true
			cutscene.get_node("Cutscene").play()
			
			$SongTimer.start()
			await $SongTimer.timeout
			
			cutscene.visible = false
			
			$AnimatedSprite2D.play("demon")
			$Sword.queue_free()
			
			music.stream = load("res://assets/music/EvilDevilPart3.mp3")
			music.play()
			
			attack = ""
			health = 100
			can_be_damaged = true
		elif health <= 0 and phase == 2:
			health = 0
			$RestTime.stop()
			$TornadoCooldown.stop()
			$AttackCooldown.stop()
			$DamageCooldown.stop()
			attacking = true
			player.health = 1000000
			var cutscene = get_parent().get_node("Cutscene")
			cutscene.visible = true
			music.stop()
			player.position = Vector2(-5000, 0)
			cutscene.get_node("Cutscene").stream = load("res://assets/videos/Fin.ogv")
			cutscene.get_node("Cutscene").play()
			await cutscene.get_node("Cutscene").finished
			player.health = 0

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
	
	$JumpAttack.monitorable = true
	$JumpAttack.monitoring = true
	await get_tree().process_frame
	await get_tree().process_frame
	for body in $JumpAttack.get_overlapping_bodies():
		if body.name == "Bello":
			body.health -= 150
	$JumpAttack.monitorable = false
	$JumpAttack.monitoring = false
	
	$CollisionShape2D.disabled = false

func tornado(speed: float = 400.0):
	attacking = true
	await jump_to(top)
	
	$Sword/TornadoAttack.monitorable = true
	$Sword/TornadoAttack.monitoring = true
	
	tornadoing = true
	
	for point in tornado_points:
		await move_to_point(point, speed)
	
	tornadoing = false
	
	$Sword/TornadoAttack.monitorable = false
	$Sword/TornadoAttack.monitoring = false
	
	$TornadoEnd.start()
	await $TornadoEnd.timeout
	
	await jump_to(center)
	
	if attacking:
		attack = "rest"
		attacking = false
	
	emit_signal("attack_finished")

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

func _on_attack_cooldown_timeout() -> void:
	attack = ""
	attacking = false
