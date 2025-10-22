extends CanvasLayer

func _process(_delta):
	$DashLeft.text = "Dashes : " + str(Globals.dash_left)
	if Globals.can_freeze:
		$FreezeCooldown.text = "Freeze !"
	else:
		$FreezeCooldown.text = "Freeze in : " + str(Globals.freeze_cooldown)
	
	
	if Globals.arrow_left >= 1:
		$Arrow1.visible = true
	else:
		$Arrow1.visible = false
	if Globals.arrow_left >= 2:
		$Arrow2.visible = true
	else:
		$Arrow2.visible = false
	if Globals.arrow_left >= 3:
		$Arrow3.visible = true
	else:
		$Arrow3.visible = false
	
	
	if Globals.health == 500:
		$Health.texture = load("res://assets/textures/Health1.png")
	elif Globals.health >= 400:
		$Health.texture = load("res://assets/textures/Health2.png")
	elif Globals.health >= 300:
		$Health.texture = load("res://assets/textures/Health3.png")
	elif Globals.health >= 200:
		$Health.texture = load("res://assets/textures/Health4.png")
	elif Globals.health >= 100:
		$Health.texture = load("res://assets/textures/Health5.png")
	else:
		$Health.texture = load("res://assets/textures/Health6.png")
	
	
	if Globals.can_heal:
		$HealCooldown.text = "Heal !"
	else:
		$HealCooldown.text = "Heal in : " + str(Globals.heal_cooldown)
