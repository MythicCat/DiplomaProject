extends Node

func _on_AttackArea_body_entered(body):
	var pos = owner.position
	body.hurt(pos)
