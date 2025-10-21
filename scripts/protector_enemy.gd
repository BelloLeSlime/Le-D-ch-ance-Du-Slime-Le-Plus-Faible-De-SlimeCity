extends CharacterBody2D

signal destroy

var health = 2
var speed = 200
var player: CharacterBody2D = null
var can_attack = true
var protecting: CharacterBody2D = null
var protect_preload = preload("res://scenes/protect.tscn")

var can_protect = true

var protect: ColorRect = null

var protected = false

var can_be_damaged = true

var mode = "passive"

func _ready():
	player = get_tree().get_root().get_node("Main/Level1/Bello")

func _physics_process(_delta):
	
	if health <= 0:
		queue_free()
	
	if protecting == null and can_protect:
		for body in $Reach.get_overlapping_bodies():
			if "Enemy" in body.name and body != self and not "Arrow" in body.name and not "Fireball" in body.name:
				if body.protected == false:
					protecting = body
					protecting.protected = true
					if not protecting.is_connected("destroy",Callable(self,"_on_destroy")):
						protecting.connect("destroy",Callable(self,"_on_destroy"))
					protect = protect_preload.instantiate()
					add_child(protect)
					protect.global_position = protecting.global_position
					protect.global_position.y -= 70
					break
	elif protecting != null:
		protect.global_position = protecting.global_position
		protect.global_position.y -= 70
	
	var dir = (player.global_position - global_position).normalized()
	
	if mode == "active":
		var distance = global_position.distance_to(player.global_position)
		if distance > 300 and $Freeze.time_left == 0:
			velocity = dir * speed
		else:
			velocity = Vector2.ZERO
	elif mode == "passive":
		for body in $Vision.get_overlapping_bodies():
			if body.name == "Bello":
				mode = "active"
	
		move_and_slide()

func damage():
	if can_be_damaged:
		$DamageCooldown.start()
		can_be_damaged = false
		if protected:
			protected = false
			emit_signal("destroy")
		else:
			if protecting != null:
				protecting.protected = false
			queue_free()
 
func _on_destroy():
	protecting = null
	protect.queue_free()
	$ProtectCooldown.start()
	can_protect = false

func _on_protect_cooldown_timeout():
	can_protect = true


func _on_damage_cooldown_timeout():
	can_be_damaged = true
