extends RigidBody2D


		
func _on_Node2D_body_entered(body):
	if body is Boss:
		print("Collided barrel")
		body.hurt(Vector2())
		get_tree().call_group("BossLogic", "_on_barrel_exploded")
		
func prepare():
	$AnimatedSprite.modulate = Color(1,1,1,0)
	$AnimationPlayer.play("respawn")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	get_tree().call_group("BossLogic", "_on_barrel_ready")


func _on_Node2D_sleeping_state_changed():
	$AnimatedSprite.play("armed")
