extends Area2D

func _on_MapPiece_body_entered(body):
	$PickUp.play()
	PlayerVariables.mapPiece = true
	$AnimatedSprite.play("die")
	yield($AnimatedSprite, "animation_finished")
	queue_free()
