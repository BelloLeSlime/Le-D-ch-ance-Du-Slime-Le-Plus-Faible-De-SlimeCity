extends CanvasLayer

var left = Vector2(958.0,221.0)
var right = Vector2(1188.0,221.0)

func move_to(destination: Vector2, duration: float = 0.5):
	var tween = create_tween()
	tween.tween_property($Panel, "position", destination, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
