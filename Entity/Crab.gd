extends Enemy

func detect_player():
	if $DetectPlayer.is_colliding() and $DetectPlayer.get_collider().name == "Player":
		if not isAttacking and not isDead and not isHurt:
			ready_attack()
