extends Area2D

export var treasureValue = 30

func _on_Item_body_entered(body):
	
	if PlayerVariables.keys <= 0:
		return
	
	PlayerVariables.keys -= 1
	set_collision_mask_bit(0,false) # disable collision area
	PlayerVariables.treasure += treasureValue # replace with coin shower
	get_tree().call_group("Gui", "update_coin_counter") # update gui coin tracker // remove when coin shower is implemented
	get_tree().call_group("Gui", "update_key_counter")
	$AnimatedSprite.play("open")
	yield($AnimatedSprite, "animation_finished")
