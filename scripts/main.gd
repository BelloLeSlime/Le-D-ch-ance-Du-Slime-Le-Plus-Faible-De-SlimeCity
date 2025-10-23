extends Node2D

var world_preload = preload("res://scenes/world.tscn")
var bello: CharacterBody2D
var world: Node2D

func _ready():
	await $Fade.fade_in(0)
	await $Fade.fade_out()

func _on_play_pressed():
	$Music.stop()
	await $Fade.fade_in()
	$Menu.visible = false
	world = world_preload.instantiate()
	add_child(world)
	$Timer.start()
	await $Timer.timeout
	await $Fade.fade_out()
	$Music.stream = load("res://assets/music/Soporific.mp3")
	$Music.play()
	$Music.volume_db = 0
	bello = get_node("World/Bello")
	bello.connect("dead", Callable(self, "_on_bello_dead"))
	Globals.playing = true
	

func _on_quit_pressed():
	await $Fade.fade_in()
	$Timer.start()
	await $Timer.timeout
	get_tree().quit()

func _on_boss_pressed():
	$Music.stop()
	await $Fade.fade_in()
	$Menu.visible = false
	world = world_preload.instantiate()
	add_child(world)
	world.get_node("Bello").position = Vector2(2960, -14170)
	$Timer.start()
	await $Timer.timeout
	await $Fade.fade_out()
	bello = get_node("World/Bello")
	bello.connect("dead", Callable(self, "_on_bello_dead"))
	Globals.playing = true

func _on_bello_dead():
	Globals.playing = false
	var camera = Camera2D.new()
	world.add_child(camera)
	camera.global_position = get_node("World/Bello/Camera2D").global_position
	camera.make_current()
	camera.zoom = get_node("World/Bello/Camera2D").zoom
	var colorrect = ColorRect.new()
	camera.add_child(colorrect)
	colorrect.color = get_node("World/Bello/Camera2D/ColorRect").color
	colorrect.size = get_node("World/Bello/Camera2D/ColorRect").size
	colorrect.position = get_node("World/Bello/Camera2D/ColorRect").position
	colorrect.z_index = get_node("World/Bello/Camera2D/ColorRect").z_index
	bello.queue_free()
	await $Fade.fade_in()
	world.queue_free()
	$Menu.visible = true
	$Music.stop()
	$Timer.start()
	await $Timer.timeout
	await $Fade.fade_out()
	$Music.stream = load("res://assets/music/LookAtTheSky.mp3")
	$Music.play()
	
