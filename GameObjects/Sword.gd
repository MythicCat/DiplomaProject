class_name Sword
extends RigidBody2D

var direction = 1

func _on_RigidBody2D_body_entered(body):
	
	set_collision_mask_bit(0, true) # after it hits something, enable collision with player so they can pick it up
	set_collision_mask_bit(4, false) # prevent enemies from constantly colliding with sword	

	$ThrowShape.set_deferred("disable", true)
	$PickUpShape.set_deferred("disable", false)
	
	if body is Enemy:
		body.hurt(Vector2(0,0))
		gravity_scale = 5
	elif body is Player:
		body.heal("sword")
		queue_free()
	else:
		if $Animation.flip_h:
			direction = -1
			
		$Animation.position = Vector2(7.2 * direction, -1.5)
		$Animation.play("embed")
		sleeping = true
