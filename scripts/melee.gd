extends Area2D


func _on_disapeer_cooldown_timeout():
	queue_free()

func _physics_process(_delta):
	for body in get_overlapping_bodies():
		if "Enemy" in body.name:
			body.damage()
	
	for area in get_overlapping_areas():
		if "EnemyArrow" in area.name:
			area.queue_free()
