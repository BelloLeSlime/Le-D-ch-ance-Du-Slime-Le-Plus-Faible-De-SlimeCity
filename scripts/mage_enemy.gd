extends CharacterBody2D

var speed = 250
var player: CharacterBody2D = null
var can_attack = true
var fireball_preload = preload("res://scenes/enemy_fireball.tscn")

func _ready():
	player = get_tree().get_root().get_node("Main/Bello")

func _physics_process(delta):
	
	var dir = (player.global_position - global_position).normalized()
	
	var distance = global_position.distance_to(player.global_position)
	if distance > 500 and $Freeze.time_left == 0:
		velocity = dir * speed
	else:
		velocity = Vector2.ZERO
		if can_attack and $Freeze.time_left == 0:
			can_attack = false
			var fireball = fireball_preload.instantiate()
			add_child(fireball)
			fireball.dir = dir
			fireball.rotation = dir.angle()
			$AttackCooldown.start()
	
	move_and_slide()

func _on_attack_cooldown_timeout():
	can_attack = true
