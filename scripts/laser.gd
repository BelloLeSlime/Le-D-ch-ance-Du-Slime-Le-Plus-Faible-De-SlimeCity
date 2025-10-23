extends Node2D

func _ready() -> void:
	var bello = get_parent().get_node("Bello")
	position = bello.position
	rotation = randf_range(0, 359)
	$Timer.start()

func _on_timer_timeout() -> void:
	$Laser.visible = true
	$Preshot.visible = false
	for body in $Area2D.get_overlapping_bodies():
		if body.name == "Bello":
			body.health -= 200
	$Lifetime.start()

func _on_lifetime_timeout() -> void:
	queue_free()
