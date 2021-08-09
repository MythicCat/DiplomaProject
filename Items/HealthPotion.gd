extends Area2D

func _on_Item_body_entered(body):
	
	if PlayerVariables.is_full_hp():
		return
	
	$PickUp.play()
	set_collision_mask_bit(0, false)
	PlayerVariables.lives += 1 # update player treasure count
	get_tree().call_group("Gui", "update_hp_bar") # update gui coin tracker
	$AnimatedSprite.play("die")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
