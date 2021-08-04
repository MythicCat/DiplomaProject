extends RigidBody2D

var reset_pos = false
var reset_position = Vector2()

func _integrate_forces(state):
	if reset_pos:
		state.transform = Transform2D(0, Vector2(3253, 4.4382))
		reset_pos = false
		sleeping = true
		
		
func _on_Node2D_body_entered(body):
	if body is Boss:
		print("Collided barrel")
		$AnimatedSprite.modulate = Color(1,1,1,0)
		$AnimatedSprite.play("idle")
		get_tree().call_group("BossLogic", "_on_barrel_exploded")
		
func reset_state(new_position : Vector2):
	reset_pos = true
	reset_position = new_position
	$Respawn.start()



func _on_Respawn_timeout():
	$AnimationPlayer.play("respawn")
