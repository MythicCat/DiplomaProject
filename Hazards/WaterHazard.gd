extends Area2D

func _on_Water_body_entered(body):
	#GameState.hurt()
	if body is Player:
		#var x_offset =$CollisionShape2D.shape.extents.x
		get_tree().call_group("GameState", "hurt", global_position, 1, 1.5)
