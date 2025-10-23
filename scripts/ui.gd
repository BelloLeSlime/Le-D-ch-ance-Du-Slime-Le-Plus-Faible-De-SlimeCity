extends CanvasLayer

func _process(_delta):
	
	if Globals.dash_left >= 1:
		$Dash1.visible = true
	else:
		$Dash1.visible = false
	if Globals.dash_left >= 2:
		$Dash2.visible = true
	else:
		$Dash2.visible = false
	
	
	
	
	if Globals.can_freeze:
		$Freeze.texture = load("res://assets/textures/flocon4.png")
	elif Globals.freeze_cooldown <= 0:
		$Freeze.texture = load("res://assets/textures/flocon3.png")
	elif Globals.freeze_cooldown <= 1:
		$Freeze.texture = load("res://assets/textures/flocon2.png")
	elif Globals.freeze_cooldown <= 2:
		$Freeze.texture = load("res://assets/textures/flocon1.png")
	else:
		$Freeze.texture = load("res://assets/textures/flocon0.png")
	
	
	
	
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
		$Heal.texture = load("res://assets/textures/heal5.png")
	elif Globals.heal_cooldown <= 1:
		$Heal.texture = load("res://assets/textures/heal4.png")
	elif Globals.heal_cooldown <= 3:
		$Heal.texture = load("res://assets/textures/heal3.png")
	elif Globals.heal_cooldown <= 6:
		$Heal.texture = load("res://assets/textures/heal2.png")
	elif Globals.heal_cooldown <= 8:
		$Heal.texture = load("res://assets/textures/heal1.png")
	else:
		$Heal.texture = load("res://assets/textures/heal0.png")
