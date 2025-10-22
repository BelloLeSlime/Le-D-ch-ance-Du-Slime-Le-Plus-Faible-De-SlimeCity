extends Node2D

func _on_bossfight_trigger_body_entered(body: Node2D) -> void:
	if body.name == "Bello":
		$TileMap.set_cell(0,Vector2i(18,1),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(18,2),0,Vector2i(1,0))
		$TileMap.set_cell(0,Vector2i(18,3),0,Vector2i(1,0))
		$BossfightTrigger.queue_free()
		$"Enemy Chef Duculte".attack = ""
