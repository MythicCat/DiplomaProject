extends Area2D



func _on_Checkpoint_body_entered(body):
	if body.name == "Player":
		$Particles2D.emitting = true
		set_collision_mask_bit(0, false)
		get_tree().call_group("GameState", "save_level")
		print("Game saved at checkpoint")
