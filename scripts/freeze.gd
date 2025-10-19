extends Area2D

func _on_disapeer_cooldown_timeout():
	queue_free()

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if "MeleeEnemy" in body.name or "RangerEnemy" in body.name or "MageEnemy" in body.name or "TankEnemy":
			var children = body.get_children()
			for child in children:
				if child.name == "Freeze":
					child.start()
