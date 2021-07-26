extends CanvasLayer

signal transitioned
var isBlack = false

func transition():
	if isBlack:
		$AnimationPlayer.play("fade_to_normal")
		isBlack = false
		print("Faded to normal.")
	else:
		$AnimationPlayer.play("fade_to_black")
		isBlack = true
		print("Faded to black.")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("transitioned")
