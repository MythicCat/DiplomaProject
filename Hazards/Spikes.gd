extends Area2D

func _on_Spikes_body_entered(body):
	get_tree().call_group("GameState", "hurt", position)
