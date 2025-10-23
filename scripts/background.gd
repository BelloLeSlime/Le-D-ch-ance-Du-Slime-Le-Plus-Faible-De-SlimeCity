extends TextureRect

@export var distance := 50.0     # déplacement total gauche/droite
@export var duration := 3.0       # temps pour aller d’un côté à l’autre
@export var wait_time := 0.5      # petite pause à chaque extrémité

var tween: Tween
var base_x: float

func _ready():
	base_x = position.x
	start_tween()


func start_tween():
	tween = create_tween()
	tween.set_loops()  # boucle infinie

	# Aller à droite
	tween.tween_property(self, "position:x", base_x + distance, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_interval(wait_time)

	# Revenir à gauche
	tween.tween_property(self, "position:x", base_x - distance, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(wait_time)
