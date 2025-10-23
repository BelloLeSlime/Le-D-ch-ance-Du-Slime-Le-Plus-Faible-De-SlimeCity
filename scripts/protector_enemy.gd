extends CharacterBody2D

signal destroy

var speed = 600
var player: CharacterBody2D = null
var can_attack = true
var protecting: CharacterBody2D = null
var protect_preload = preload("res://scenes/protect.tscn")

var can_protect = true

var protect: Node2D = null

var protected = false

var can_be_damaged = true

var mode = "passive"

func _ready():
	player = get_tree().get_root().get_node("Main/World/Bello")

func _physics_process(_delta):
	if Globals.playing:
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
	if is_instance_valid(protect):
		protect.queue_free()
	$ProtectCooldown.start()
	can_protect = false

func _on_protect_cooldown_timeout():
	can_protect = true


func _on_damage_cooldown_timeout():
	can_be_damaged = true
