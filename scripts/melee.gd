extends Area2D


func _on_disapeer_cooldown_timeout():
	queue_free()

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if "MeleeEnemy" in body.name or "RangerEnemy" in body.name or "MageEnemy" in body.name:
			body.queue_free()
		elif "TankEnemy" in body.name:
			body.health -= 1
	for area in get_overlapping_areas():
		if "EnemyArrow" in area.name:
			area.queue_free()
