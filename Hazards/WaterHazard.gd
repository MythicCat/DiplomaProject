extends Area2D

func _on_Water_body_entered(body):
	#GameState.hurt()
	get_tree().call_group("GameState", "hurt", position)
