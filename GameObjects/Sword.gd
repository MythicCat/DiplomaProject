class_name Sword
extends RigidBody2D

var direction = 1
var collision_angle = 0
var collision_pos
onready var player = get_parent().get_parent().get_parent()

func _on_RigidBody2D_body_entered(body):
	
	set_collision_mask_bit(0, true) # after it hits something, enable collision with player so they can pick it up
	set_collision_mask_bit(4, false) # prevent enemies from constantly colliding with sword
	set_collision_layer_bit(5, false)

	$ReturnTimer.start()

	$ThrowShape.set_deferred("disable", true)
	$PickUpShape.set_deferred("disable", false)
	
	#$ThrowShape.disabled = true
	#$PickUpShape.disabled = false
	
	if body is Enemy:
		body.hurt(global_position)
		gravity_scale = 5
	elif body is Player:
		body.heal("sword")
		queue_free()
	elif body is Boss:
		linear_velocity -= Vector2(100, 100)
	else:
		if $Animation.flip_h:
			direction = -1
			
		$Animation.rotation_degrees = collision_angle
		$Animation.position = Vector2(7.2 * direction, -1.5) # fix this, calculate position based on collision point 
		$Animation.look_at(collision_pos)
		$Animation.play("embed")
		sleeping = true

func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		var position = state.get_contact_local_position(0)
		var angle = state.get_contact_local_normal(0).angle()
		collision_angle = angle * 180 / PI
		#print(collision_angle)
		collision_pos = to_local(position) # this could be it



func _on_ReturnTimer_timeout():
	$TimeoutFade.play("fade")
	yield($TimeoutFade, "animation_finished")
	player.heal("sword")
	queue_free()
