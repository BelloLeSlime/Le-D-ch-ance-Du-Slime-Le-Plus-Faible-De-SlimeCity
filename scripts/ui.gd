extends CanvasLayer

func _process(_delta):
	$DashLeft.text = "Dashes : " + str(Globals.dash_left)
	if Globals.can_freeze:
		$FreezeCooldown.text = "Freeze !"
	else:
		$FreezeCooldown.text = "Freeze in : " + str(Globals.freeze_cooldown)
	$ArrowLeft.text = "Arrows : " + str(Globals.arrow_left)
	$Health.text = "Health : " + str(Globals.health)
	if Globals.can_heal:
		$HealCooldown.text = "Heal !"
	else:
		$HealCooldown.text = "Heal in : " + str(Globals.heal_cooldown)
