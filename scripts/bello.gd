extends CharacterBody2D

@export var speed = 400
var input_vector
var dash_left = 3
var melee_preload = preload("res://scenes/melee.tscn")
var can_melee = true
var arrow_preload = preload("res://scenes/arrow.tscn")
var freeze_preload = preload("res://scenes/freeze.tscn")
var can_freeze = true
var arrow_left = 3

var can_heal = true

var health = 500
var last_health = 500

var shake = false
var shake_duration = 0.5
var shake_strenght = 10.0

func _physics_process(_delta):
	
	if health <= 0:
		get_tree().quit()
	
	if last_health > health:
		shake = true
		shake_duration = 0.5
		shake_strenght = 10.0
		$CameraShake.wait_time = shake_duration
		$CameraShake.start()
	
	if shake:
		$Camera2D.offset.x = randf_range(0,shake_strenght)
		$Camera2D.offset.y = randf_range(0,shake_strenght)
	else:
		$Camera2D.offset.x = 0
		$Camera2D.offset.y = 0
	
	input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("d") - Input.get_action_strength("q")
	input_vector.y = Input.get_action_strength("s") - Input.get_action_strength("z")
	input_vector = input_vector.normalized()
	
	if Input.is_action_just_pressed("shift") and dash_left > 0:
		speed = 1500
		dash_left -= 1
		$DashSpeedCooldown.start()
	
	if Input.is_action_just_pressed("left_click") and can_melee:
		can_melee = false
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - global_position).normalized()
		var melee = melee_preload.instantiate()
		add_child(melee)
		
		melee.global_position = global_position + dir * 50
		melee.rotation = dir.angle()
		
		$MeleeCooldown.start()
	
	if Input.is_action_just_pressed("right_click") and arrow_left > 0:
		arrow_left -= 1
		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - global_position).normalized()
		var arrow = arrow_preload.instantiate()
		add_child(arrow)
		arrow.dir = dir
		arrow.rotation = dir.angle()
		$ArrowCooldown.start()
	
	if Input.is_action_just_pressed("e") and can_freeze:
		can_freeze = false
		var freeze = freeze_preload.instantiate()
		add_child(freeze)
		
		$FreezeCooldown.start()
	
	if Input.is_action_just_pressed("a") and can_heal:
		can_heal = false
		$HealCooldown.start()
		health += 250
		if health >= 500:
			health = 500
	
	Globals.dash_left = dash_left
	Globals.freeze_cooldown = int($FreezeCooldown.time_left)
	Globals.can_freeze = can_freeze
	Globals.arrow_left = arrow_left
	Globals.health = health
	Globals.can_heal = can_heal
	Globals.heal_cooldown = int($HealCooldown.time_left)
	
	velocity = input_vector * speed
	move_and_slide()
	
	last_health = health

func _on_dash_speed_cooldown_timeout():
	speed = 400
	$DashRecoverCooldown.start()

func _on_dash_recover_cooldown_timeout():
	dash_left += 1
	if dash_left > 2:
		dash_left = 2

func _on_melee_cooldown_timeout():
	can_melee = true

func _on_arrow_cooldown_timeout():
	arrow_left += 1
	if arrow_left > 3:
		arrow_left = 3

func _on_freeze_cooldown_timeout():
	can_freeze = true

func _on_camera_shake_timeout():
	shake = false

func _on_heal_cooldown_timeout():
	can_heal = true
