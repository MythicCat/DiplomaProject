extends Enemy

export var attackCooldown = 3
var canAttack = true

func detect_player():
	if $DetectPlayer.is_colliding() and $DetectPlayer.get_collider().name == "Player":
		if not isAttacking and not isDead and canAttack:
			ready_attack()

 
func move(delta):	
	
	if isHurt:
		return
	
	if (is_on_wall() or !hit_ledge.is_colliding()) and not isDead and not in_air:
		scale.x = -scale.x
		direction = -direction

		if isAttacking:
			motion = Vector2(abs(motion.x) * direction * 2, -150)
			isAttacking = false
			canAttack = false
			$AttackCooldown.start(attackCooldown)
	
	if not isDead and not isHurt and not isAttacking:	
		motion.x = speed * direction
	elif isDead:
		motion.x = lerp(motion.x, 0, 0.1)
	else:
		motion.x = lerp(motion.x, 150*direction, 0.25)

func attack():	
	animated_sprite.play("attack")


func _on_AttackCooldown_timeout():
	canAttack = true

func hurt(enemyPosition : Vector2):
	if isAttacking:
		canAttack = false
		$AttackCooldown.start(attackCooldown + 2)
		
	.hurt(enemyPosition)
