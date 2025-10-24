extends Node2D

@onready var music: AudioStreamPlayer = get_parent().get_node("Music")

var already_left = false
var already_right = false
var already_shift = false
var already_e = false
var already_a = false

func _on_level_2_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		if not music.stream == load("res://assets/music/Control.mp3"):
			await music.fade_out()
			music.stream = load("res://assets/music/Control.mp3")
			music.play()

func _on_level_1_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		if not music.stream == load("res://assets/music/Soporific.mp3"):
			await music.fade_out()
			music.stream = load("res://assets/music/Soporific.mp3")
			music.play()

func _on_level_3_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		await music.fade_out()

func _on_level_2_other_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		if not music.stream == load("res://assets/music/Control.mp3"):
			await music.fade_out()
			music.stream = load("res://assets/music/Control.mp3")
			music.play()

func _on_bossfight_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		$TileMap.set_cell(0,Vector2i(41,-448),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-447),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-446),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-445),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-444),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-443),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(41,-442),0,Vector2i(1,0))
		$BossfightTrigger.queue_free()
		$"Enemy Chef Duculte".attack = "rest"
		$"Enemy Chef Duculte".can_be_damaged = true
		music.stream = load("res://assets/music/EvilDevilPart1.mp3")
		music.volume_db = -5
		music.play()
		$BossHealth.visible = true

func _process(_delta):
	$BossHealth/Label.text = "CHEF DUCULTE : " + str($"Enemy Chef Duculte".health * 10)

func _on_tuto_left_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not already_left:
		already_left = true
		$Tutorial.visible = true
		$Tutorial/Panel/AnimatedSprite2D.play("left")
		$Tutorial.move_to($Tutorial.left)
		while not Input.is_action_just_pressed("left_click"):
			await get_tree().process_frame
		await $Tutorial.move_to($Tutorial.right)
		$Tutorial.visible = false

func _on_tuto_right_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not already_right:
		already_right = true
		$Tutorial.visible = true
		$Tutorial/Panel/AnimatedSprite2D.play("right")
		$Tutorial.move_to($Tutorial.left)
		while not Input.is_action_just_pressed("right_click"):
			await get_tree().process_frame
		await $Tutorial.move_to($Tutorial.right)
		$Tutorial.visible = false

func _on_tuto_shift_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not already_shift:
		already_shift = true
		$Tutorial.visible = true
		$Tutorial/Panel/AnimatedSprite2D.play("shift")
		$Tutorial.move_to($Tutorial.left)
		while not Input.is_action_just_pressed("shift"):
			await get_tree().process_frame
		await $Tutorial.move_to($Tutorial.right)
		$Tutorial.visible = false

func _on_tuto_e_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not already_e:
		already_e = true
		$Tutorial.visible = true
		$Tutorial/Panel/AnimatedSprite2D.play("e")
		$Tutorial.move_to($Tutorial.left)
		while not Input.is_action_just_pressed("e"):
			await get_tree().process_frame
		await $Tutorial.move_to($Tutorial.right)
		$Tutorial.visible = false

func _on_tuto_a_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not already_a:
		already_a = true
		$Tutorial.visible = true
		$Tutorial/Panel/AnimatedSprite2D.play("a")
		$Tutorial.move_to($Tutorial.left)
		while not Input.is_action_just_pressed("a"):
			await get_tree().process_frame
		await $Tutorial.move_to($Tutorial.right)
		$Tutorial.visible = false
