extends Node2D

var can_attack = true

func _ready():
	
	var bello: CharacterBody2D = get_parent().get_node("Bello")
	
	if Globals.playing:
		position = bello.position
	
		await $Timer.timeout
		
		$Fire1.visible = true
		$Fire1.frame = 0
		$Fire1.play()
		$Fire2.visible = true
		$Fire2.frame = 2
		$Fire2.play()
		$Fire3.visible = true
		$Fire3.frame = 4
		$Fire3.play()
		
		for body in $Area2D.get_overlapping_bodies():
				if body.name == "Bello":
					if can_attack:
						body.health -= 200
		
		$Lifetime.start()

func _on_attack_cooldown_timeout() -> void:
	can_attack = true

func _on_lifetime_timeout() -> void:
	queue_free()

func _process(_delta: float) -> void:
	if $Timer.time_left == 0:
		for body in $Area2D.get_overlapping_bodies():
				if body.name == "Bello":
					if can_attack:
						body.health -= 20
						can_attack = false
