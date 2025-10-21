extends CharacterBody2D

var phase = 1
var health = 25
var player: CharacterBody2D
var attack: String = ""

const top = Vector2(3605,-370)

func _ready():
	player = get_tree().get_root().get_node("Main/Level3/Bello")

func _physics_process(_delta):
	if Input.is_action_just_pressed("e"):
		jump_to(top)

func damage():
	health -= 1
	if health <= 0:
		phase = 2

func jump_to(target_position: Vector2):
	
	$CollisionShape2D.disabled = true

	var jump_height := -3000
	var up_duration := 1
	var down_duration := 1

	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y + jump_height, up_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished

	global_position.x = target_position.x

	var tween_down = create_tween()
	tween_down.tween_property(self, "position:y", target_position.y, down_duration).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	
	await tween_down.finished

	$CollisionShape2D.disabled = false
