extends AudioStreamPlayer

@export var fade_duration := 5.0  # durée du fade-out (en secondes)

func fade_out():
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -80, fade_duration) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_fade_finished"))
	return await tween.finished

func _on_fade_finished():
	stop()
	volume_db = 0  # 🔥 prêt pour la prochaine lecture
