extends CharacterBody2D

var speed = 250
var player: CharacterBody2D = null
var can_attack = true
var arrow_preload = preload("res://scenes/enemy_arrow.tscn")

func _ready():
	player = get_tree().get_root().get_node("Main/Bello")

func _physics_process(delta):
	
	var dir = (player.global_position - global_position).normalized()
	
	var distance = global_position.distance_to(player.global_position)
	if distance > 300 and $Freeze.time_left == 0:
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
		if can_attack and $Freeze.time_left == 0:
			can_attack = false
			var arrow = arrow_preload.instantiate()
			add_child(arrow)
			arrow.dir = dir
			arrow.rotation = dir.angle()
			$AttackCooldown.start()
	
	move_and_slide()

func _on_attack_cooldown_timeout():
	can_attack = true
