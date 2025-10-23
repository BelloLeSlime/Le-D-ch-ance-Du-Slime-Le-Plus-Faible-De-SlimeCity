extends Node2D

@onready var music: AudioStreamPlayer = get_parent().get_node("Music")

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
		$BossfightTrigger.queue_free()
		$"Enemy Chef Duculte".attack = "rest"
		$"Enemy Chef Duculte".can_be_damaged = true
		music.stream = load("res://assets/music/EvilDevilPart1.mp3")
		music.volume_db = -5
		music.play()
		$BossHealth.visible = true

func _process(_delta):
	$BossHealth/Label.text = "CHEF DUCULTE : " + str($"Enemy Chef Duculte".health * 10)
