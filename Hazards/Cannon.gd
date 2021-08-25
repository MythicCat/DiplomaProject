extends Node2D

export var firing_timer = 3
var fired = false

func _process(delta):
	if fired:
		$CannonSprite.play("idle")
	else:
		$CannonSprite.play("attack")

func _on_Timer_timeout():
	$FireEffect.stop()
	$FireEffect.frame = 0
	fired = false

func _on_AnimatedSprite_animation_finished():
	if $CannonSprite.animation == "attack":
		fired = true
		$Timer.start(firing_timer)


func _on_CannonSprite_frame_changed():
	if $CannonSprite.frame == 3:
		$FireEffect.play("fire_effect")
		$AudioStreamPlayer.play()
		$RayCast2D.add_child(load("res://Hazards/Cannonball.tscn").instance())
