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
	
	
	$Health.text = "Health : " + str(Globals.health)
	if Globals.can_heal:
		$HealCooldown.text = "Heal !"
	else:
		$HealCooldown.text = "Heal in : " + str(Globals.heal_cooldown)
