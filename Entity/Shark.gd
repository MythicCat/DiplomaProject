extends Enemy

onready var timer = $JumpTimer

var canAttack = true

export var attackCooldown = 2


func hurt(enemyPosition : Vector2):
	canAttack = false
	$HurtSound.play()
	.hurt(enemyPosition)

func attack():

	motion = Vector2(600 * direction,-200) 
	timer.start()
	yield(timer, "timeout")
	canAttack = false
	$AttackCooldown.start(attackCooldown)
	
	$AttackSound.play()
	.attack()
	
	
	
func detect_player():
	if $DetectPlayer.is_colliding() and $DetectPlayer.get_collider().name == "Player":
		if not isAttacking and not isDead and canAttack:
			ready_attack()

func _on_AttackCooldown_timeout():
	canAttack = true
