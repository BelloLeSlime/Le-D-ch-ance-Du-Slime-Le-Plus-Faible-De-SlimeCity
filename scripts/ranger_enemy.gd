extends CharacterBody2D

signal destroy

var speed = 250
var player: CharacterBody2D = null
var can_attack = true
var arrow_preload = preload("res://scenes/enemy_arrow.tscn")

var protected = false
var can_be_damaged = true

var mode = "passive"

func _ready():
	player = get_tree().get_root().get_node("Main/World/Bello")
	$AnimatedSprite2D.play()

func _physics_process(_delta):
	if Globals.playing:
		var dir = (player.global_position - global_position).normalized()
		
		$Bow.rotation = dir.angle() + 45
		$Bow.position = dir * 100
		
		if $AttackCooldown.time_left <= 0.5:
			$Bow.texture = load("res://assets/textures/bow_arrow.png")
		else:
			$Bow.texture = load("res://assets/textures/bow.png")
		
		if mode == "active":
			var distance = global_position.distance_to(player.global_position)
			if distance > 300 and $Freeze.time_left == 0:
				velocity = dir * speed
			else:
				velocity = Vector2.ZERO
				if can_attack and $Freeze.time_left == 0:
					$Arrow.play()
					can_attack = false
					var arrow = arrow_preload.instantiate()
					add_child(arrow)
					arrow.dir = dir
					arrow.rotation = dir.angle()
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
		$Damage.play()
		$DamageCooldown.start()
		can_be_damaged = false
		if protected:
			protected = false
			emit_signal("destroy")
		else:
			$CollisionShape2D.disabled = true
			can_attack = false
			visible = false
			$AttackCooldown.stop()
			await $Damage.finished
			queue_free()

func _on_damage_cooldown_timeout():
	can_be_damaged = true
