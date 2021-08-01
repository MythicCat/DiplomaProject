extends Enemy

onready var timer = $JumpTimer

var canAttack = true

export var attackCooldown = 2


func attack():

	motion = Vector2(600 * direction,-200)
	timer.start()
	yield(timer, "timeout")
	
	animated_sprite.play("attack")
	$Attack.set_collision_mask_bit(0, true)
	yield(animated_sprite, "animation_finished")
	$Attack.set_collision_mask_bit(0, false)
	canAttack = false
	$AttackCooldown.start(attackCooldown)
	isAttacking = false

func _on_AttackCooldown_timeout():
	canAttack = true
