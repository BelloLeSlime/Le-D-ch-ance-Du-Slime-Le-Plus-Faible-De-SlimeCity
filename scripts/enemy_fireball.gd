extends Area2D

var dir
var speed = 1500

func _physics_process(delta):
	global_position += dir * speed * delta
	for body in get_overlapping_bodies():
		if "Bello" in body.name:
			body.health -= 20
			queue_free()
		if body.name == "Tilemap":
			queue_free()

func _on_lifetime_timeout():
	queue_free()
