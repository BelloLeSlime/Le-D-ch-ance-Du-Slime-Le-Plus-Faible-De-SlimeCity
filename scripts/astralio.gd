extends StaticBody2D

var speaked = false

func _ready():
	$AnimatedSprite2D.play()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bello" and not speaked:
		speaked = true
		$Speak.play()
