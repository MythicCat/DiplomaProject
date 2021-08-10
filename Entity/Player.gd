class_name Player
extends KinematicBody2D


var motion = Vector2(0,0)
var attackNum = 1
var isAttacking = false
var isHurt = false
var animAffix = "_sword"
var isDead = false
var isImmune = false

const SPEED = 145
const GRAVITY = 800
const UP = Vector2(0,-1) # for move_and_slide ( -1 -> treat walls and floor differently)
const JUMP_SPEED = 340
const FRICTION = 0.25
const AIR_FRICTION = 0.1
const WORLD_LIMIT = 500
const KNOCKBACK = 200

onready var animated_sprite = $AnimatedSprite
onready var SwordThrow = $AnimatedSprite/ThrowPoint

signal animate


func _physics_process(delta): # delta is the time difference between frames, multiply by delta to adjust for FPS drops
	
	move(delta)
	if not isDead:
		jump(delta)
		attack()
		throwSword()
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
	if Input.is_action_pressed("jump") and is_on_floor():
		motion.y = -JUMP_SPEED
	elif Input.is_action_just_pressed("drop") and is_on_floor():
		position.y += 1

func attack():
	if Input.is_action_just_pressed("attack") and animAffix == "_sword" and not isAttacking:
		isAttacking = true
		
		#get correct attack Area2D box and enable it
		get_node("Sounds/Attack" + str(randi()%2+1)).play()
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
	emit_signal("animate", motion, is_on_floor(), isDead, animAffix)
	
	
func hurt(enemyPosition : Vector2, knockback_factor = 1):
	if isDead:
		return
	
	isHurt = true
	isImmune = true
	
	# disable any active attacks
	isAttacking = false
	get_node("AttackArea" + String(attackNum) + "/CollisionShape2D").disabled = true
		
	position.y -= 10
	
	get_tree().call_group("Gui", "update_hp_bar")
	yield(get_tree(), "idle_frame")
	
	if PlayerVariables.lives <= 0:
		isDead = true	
			
	if not isDead:
		knockback(enemyPosition, knockback_factor)
		get_node("Sounds/Hurt" + str(randi()%3+1)).play()
		animated_sprite.play("hurt" + animAffix)
		yield(animated_sprite, "animation_finished")
		$AnimationPlayer.play("immunity")
		isHurt = false
	else:
		knockback(enemyPosition, knockback_factor)
		$Sounds/Dead.play()
		animated_sprite.play("hurt_dead")
		

	

func knockback(enemyPosition : Vector2, h_knockback_factor = 1, v_knockback_factor = 1):
	if enemyPosition.x > position.x: # TODO fix this, check if player is further than half of enemy collision box away
		motion = Vector2(-KNOCKBACK * h_knockback_factor, (-JUMP_SPEED/2) * v_knockback_factor)
	else:
		motion = Vector2( KNOCKBACK * h_knockback_factor, (-JUMP_SPEED/2) * v_knockback_factor)

	#$HurtSFX.play()
	
func pick_up(pick_up_type):
	if pick_up_type == "sword":
		animAffix = "_sword"

func throwSword():
	if Input.is_action_just_pressed("throw") and animAffix == "_sword":
		$Sounds/SwordThrow.play()
		SwordThrow.throw(animated_sprite.flip_h)
		animAffix = ""


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
	
	if animated_sprite.animation == "hurt_dead":
		isHurt = false
		
	if "fall" in animated_sprite.animation and is_on_floor():
		animated_sprite.play("land" + PlayerVariables.animation_affix);


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "immunity":
		isImmune = false


func _get_camera():
	return $Camera2D
