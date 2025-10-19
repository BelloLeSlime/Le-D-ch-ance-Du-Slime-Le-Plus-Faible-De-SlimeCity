extends Area2D

var dir
var speed = 1100

func _physics_process(delta):
	global_position += dir * speed * delta
	for body in get_overlapping_bodies():
		if "MeleeEnemy" in body.name or "RangerEnemy" in body.name or "MageEnemy" in body.name:
			body.queue_free()
			queue_free()
		elif "TankEnemy" in body.name:
			body.health -= 1
			queue_free()
	
	for area in get_overlapping_areas():
		if "EnemyArrow" in area.name:
			area.queue_free()
			queue_free()

func _on_lifetime_timeout():
	queue_free()
