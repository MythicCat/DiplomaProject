extends Area2D

func _on_Item_body_entered(body):
	set_collision_mask_bit(0,false) # disable collision area
	PlayerVariables.treasure += 10 # replace with coin shower
	get_tree().call_group("Gui", "update_coin_counter") # update gui coin tracker // remove when coin shower is implemented
	$AnimatedSprite.play("open")
	yield($AnimatedSprite, "animation_finished")
