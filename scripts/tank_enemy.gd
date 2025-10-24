extends CharacterBody2D

signal destroy

var health = 2
var speed = 250
var player: CharacterBody2D = null
var can_attack = true

var protected = false

var can_be_damaged = true

var mode = "passive"

func _ready():
	player = get_tree().get_root().get_node("Main/World/Bello")
	$AnimatedSprite2D.play("walk")

func _physics_process(_delta):
	if Globals.playing:
		for body in $Attack.get_overlapping_bodies():
			if body.name == "Bello" and can_attack and $Freeze.time_left == 0:
				can_attack = false
				body.health -= 35
				$AttackCooldown.start()
		
		var dir = (player.global_position - global_position).normalized()
		
		$Shield.rotation = dir.angle() + 270
		$Shield.position = dir * 100
		
		if mode == "active":
			var distance = global_position.distance_to(player.global_position)
			if distance > 60 and $Freeze.time_left == 0:
				velocity = dir * speed
			else:
				velocity = Vector2.ZERO
			
			move_and_slide()
		elif mode == "passive":
			for body in $Vision.get_overlapping_bodies():
				if body.name == "Bello":
					mode = "active"

func _on_attack_cooldown_timeout():
	can_attack = true

func damage():
	if can_be_damaged:
		$DamageCooldown.start()
		can_be_damaged = false
		if protected:
			$Damage.play()
			protected = false
			emit_signal("destroy")
		else:
			health -= 1
			$Shield.visible = false
			if health <= 0:
				$Damage.play()
				$CollisionShape2D.disabled = true
				visible = false
				can_attack = false
				$AttackCooldown.stop()
				await $ Damage.finished
				queue_free()
			else:
				$Break.play()

func _on_damage_cooldown_timeout():
	can_be_damaged = true
