extends KinematicBody2D


const SPEED = 145
const GRAVITY = 800
const UP = Vector2(0,-1) # for move_and_slide ( -1 -> treat walls and floor differently)
const JUMP_SPEED = 340
const FRICTION = 0.25
const AIR_FRICTION = 0.1
const WORLD_LIMIT = 500
const KNOCKBACK = 120


var motion = Vector2(0,0)
var attackNum = 1
var isAttacking = false
var isHurt = false
var hasSword = true
var isDead = false

onready var animated_sprite = $AnimatedSprite

signal animate


func _physics_process(delta): # delta is the time difference between frames, multiply by delta to adjust for FPS drops
		
	move(delta)
	jump(delta)
	attack()
	apply_gravity(delta)
	move_and_slide(motion, UP)
	animate()


func apply_gravity(delta):
	
	if is_on_floor() and motion.y > 0:
		motion.y = GRAVITY * delta
			
	elif is_on_ceiling():
		motion.y = 1
		
	else:
		motion.y += GRAVITY * delta
		
	if position.y > WORLD_LIMIT:
		get_tree().call_group("GameState", "hurt") # replace with -1 hp and reset to last safe position?


func jump(delta):
	if Input.is_action_pressed("jump") and is_on_floor() and not isDead:
		motion.y = -JUMP_SPEED


func attack():
	if Input.is_action_just_pressed("attack"):
		isAttacking = true
		
		#get correct attack Area2D box and enable it
		var attackArea = get_node("AttackArea" + String(attackNum) + "/CollisionShape2D")
		if animated_sprite.flip_h:
			attackArea.position.x = -abs(attackArea.position.x)
		else:
			attackArea.position.x = abs(attackArea.position.x)
			
		attackArea.disabled = false
		animated_sprite.play("attack" + String(attackNum))
		


func move(delta):
	
	if isHurt:
		return
		
	var friction
	
	if is_on_floor():
		friction = FRICTION
	else:
		friction = AIR_FRICTION
	
	if Input.is_action_pressed("left") and !Input.is_action_pressed("right") and not isDead:
		motion.x = -SPEED
		animated_sprite.flip_h = true	
	elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and not isDead:
		motion.x = SPEED
		animated_sprite.flip_h = false
	elif abs(motion.x) > 0.5 or isDead:
		motion.x = lerp(motion.x, 0, friction)	
	else:
		motion.x = 0	


func animate():
	
	
	if isAttacking or isHurt:
		return
		
	emit_signal("animate", motion, is_on_floor(), isDead)
	
	
func hurt(enemyPosition : Vector2):
	
	if isDead:
		return
	
	isHurt = true
	position.y -= 1
	
	get_tree().call_group("Gui", "update_hp_bar")
	yield(get_tree(), "idle_frame")
	
	if PlayerVariables.lives <= 0:
		isDead = true
	
	if not isDead:
		animated_sprite.play("hurt" + PlayerVariables.animation_affix)
	else:
		animated_sprite.play("hurt_dead")
		
	if enemyPosition.x > position.x: # TODO fix this, check if player is further than half of enemy collision box away
		motion = Vector2(-KNOCKBACK, -JUMP_SPEED)
	else:
		motion = Vector2( KNOCKBACK, -JUMP_SPEED)

	#$HurtSFX.play()


func _on_AnimatedSprite_animation_finished():
	
	if "attack" in animated_sprite.animation:
		isAttacking = false
		#get correct attack Area2D box and disable it
		get_node("AttackArea" + String(attackNum) + "/CollisionShape2D").disabled = true	
		#set next attack animation
		if attackNum < 3:
			attackNum += 1
		else:
			attackNum = 1
	
	if "hurt" in animated_sprite.animation:
		isHurt = false
		
	if "fall" in animated_sprite.animation and is_on_floor():
		animated_sprite.play("land" + PlayerVariables.animation_affix);
