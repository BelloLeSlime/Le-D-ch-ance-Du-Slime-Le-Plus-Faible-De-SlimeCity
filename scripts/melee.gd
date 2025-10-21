extends Node2D

@export var lifetime := 0.2
@export var angle_range := deg_to_rad(80) # 10° de chaque côté
@export var distance := 10.0

var start_angle := 0.0
var elapsed := 0.0
var dir_angle := 0.0
var direction_sign := 1 # +1 = gauche→droite, -1 = droite→gauche

func _on_disapeer_cooldown_timeout():
	queue_free()

func setup(direction: Vector2, reverse: bool = false):
	dir_angle = direction.angle()
	direction_sign = -1 if reverse else 1
	
	if reverse:
		$Normal.visible = false
	else:
		$Reverse.visible = false
	
	start_angle = dir_angle - (angle_range / 2) * direction_sign
	rotation = start_angle
	position = direction.normalized() * distance

func _physics_process(delta):
	
	elapsed += delta
	var t := elapsed / lifetime
	if t > 1.0:
		t = 1.0
	
	var current_angle = start_angle + angle_range * t * direction_sign
	rotation = current_angle
	
	position = Vector2.RIGHT.rotated(current_angle) * distance
	
	for body in $Area2D.get_overlapping_bodies():
		if "Enemy" in body.name:
			body.damage()
	
	for area in $Area2D.get_overlapping_areas():
		if "EnemyArrow" in area.name:
			area.queue_free()
