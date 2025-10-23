extends Area2D

func _on_disapeer_cooldown_timeout():
	queue_free()

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if "Enemy" in body.name or "@CharacterBody2D" in body.name:
			var children = body.get_children()
			for child in children:
				if child.name == "Freeze":
					child.start()
