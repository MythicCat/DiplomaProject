extends Area2D

func _on_Spikes_body_entered(body):
	if body is Player:
		get_tree().call_group("GameState", "hurt", global_position + Vector2($Sprite.texture.get_width(), 0), 1, 3)
