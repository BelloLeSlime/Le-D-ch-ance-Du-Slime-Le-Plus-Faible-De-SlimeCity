extends Node2D

var level1_preload = preload("res://scenes/level1.tscn")

var level3_preload = preload("res://scenes/level3.tscn")

func _on_play_pressed():
	var level1 = level1_preload.instantiate()
	add_child(level1)
	$Menu.visible = false


func _on_quit_pressed():
	get_tree().quit()

func _on_boss_pressed():
	var level3 = level3_preload.instantiate()
	add_child(level3)
	$Menu.visible = false
