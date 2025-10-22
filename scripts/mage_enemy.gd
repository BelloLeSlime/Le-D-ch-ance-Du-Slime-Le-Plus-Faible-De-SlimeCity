extends CharacterBody2D

signal destroy

var speed = 250
var player: CharacterBody2D = null
var can_attack = true
var fireball_preload = preload("res://scenes/enemy_fireball.tscn")

var protected = false

var can_be_damaged = true

var mode = "passive"

func _ready():
	player = get_tree().get_root().get_node("Main/Level1/Bello")
	$AnimatedSprite2D.play("walk")
	
func _physics_process(_delta):
	
	var dir = (player.global_position - global_position).normalized()
	
	$Baton.rotation = dir.angle() + 90
	$Baton.position = dir * 200
	
	var distance = global_position.distance_to(player.global_position)
	
	if mode == "active":
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
	elif mode == "passive":
		for body in $Vision.get_overlapping_bodies():
			if body.name == "Bello":
				mode = "active"
	
	move_and_slide()

func _on_attack_cooldown_timeout():
	can_attack = true

func damage():
	if can_be_damaged:
		$DamageCooldown.start()
		can_be_damaged = false
		if protected:
			protected = false
			emit_signal("destroy")
		else:
			queue_free()

func _on_damage_cooldown_timeout():
	can_be_damaged = true
