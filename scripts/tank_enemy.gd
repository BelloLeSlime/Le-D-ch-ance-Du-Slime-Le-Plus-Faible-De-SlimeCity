extends CharacterBody2D

var health = 2
var speed = 150
var player: CharacterBody2D = null
var can_attack = true

func _ready():
	player = get_tree().get_root().get_node("Main/Bello")

func _physics_process(delta):
	
	if health <= 0:
		queue_free()
	
	for body in $Attack.get_overlapping_bodies():
		if body.name == "Bello" and can_attack and $Freeze.time_left == 0:
			can_attack = false
			body.health -= 35
			$AttackCooldown.start()
	
	var dir = (player.global_position - global_position).normalized()
	
	var distance = global_position.distance_to(player.global_position)
	if distance > 60 and $Freeze.time_left == 0:
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_attack_cooldown_timeout():
	can_attack = true
