class_name Enemy
extends KinematicBody2D

const GRAVITY = 800
const UP = Vector2(0,-1) # for move_and_slide ( -1 -> treat walls and floor differently)
const JUMP_SPEED = 340
const FRICTION = 0.25
const AIR_FRICTION = 0.1
const KNOCKBACK = 120
const BASE_SPEED = 60

export var speed = 60
export var hp = 3
var motion = Vector2(0,0)
var direction = -1
var isHurt = false
var isDead = false
var isAttacking = false
var in_air = false

onready var animated_sprite = $AnimatedSprite
onready var hit_ledge = $DetectLedge
onready var touchArea = $DamageOnTouch/CollisionShape2D
	
func _physics_process(delta):
	
	move(delta)
	if not isDead:
		detect_player()
	animate()	
	apply_gravity(delta)
	move_and_slide(motion, UP)

	
func apply_gravity(delta):
	if is_on_floor() and motion.y > 0:
		motion.y = GRAVITY * delta
		in_air = false
	elif is_on_ceiling():
		motion.y = 1
	else:
		motion.y += GRAVITY * delta
		in_air = true
		
		
func move(delta):	
	
	if isHurt:
		return
	
	if (is_on_wall() or !hit_ledge.is_colliding()) and not isDead and not isAttacking and not in_air:
		scale.x = -scale.x
		direction = -direction
	
	if not isDead and not isHurt and not isAttacking and not in_air:	
		motion.x = speed * direction
	else:
		motion.x = lerp(motion.x, 0, 0.1)

	
	
func animate():
	
	if isHurt or isAttacking:
		return
	
	if scale.x > 0:
		animated_sprite.flip_h = false
	else:
		animated_sprite.flip_h = true
	
	if abs(motion.x) > 0 and not isDead:
		animated_sprite.play("run")
	elif isDead:
		animated_sprite.play("dead")
	
	
func hurt(enemyPosition : Vector2):
	
	if isDead:
		return
	
	hp -= 1
	isHurt = true
	isAttacking = false
	motion.x = speed * direction
	$Attack.set_collision_mask_bit(0,false)
	
	if enemyPosition.x > position.x: 
		motion = Vector2(-KNOCKBACK, -JUMP_SPEED/2)
	else:
		motion = Vector2( KNOCKBACK, -JUMP_SPEED/2)
			
	if hp <= 0:
		isDead = true
		animated_sprite.play("hurt_dead")
		die()
	else:
		animated_sprite.play("hurt")			

		
func die():
	set_collision_mask_bit(0,false) # disable collision shapes to prevent incorrect collisions
	set_collision_layer_bit(4, false)
	$DamageOnTouch.set_collision_mask_bit(0, false)


func _on_AnimatedSprite_animation_finished():	
	if "hurt" in animated_sprite.animation:
		isHurt = false

	if animated_sprite.animation == "dead":
		$DeadFade.play("fade_out")
		yield($DeadFade, "animation_finished")
		queue_free()
			
	
func _on_DamageOnTouch_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("GameState", "hurt", position)


func detect_player():
	pass


func ready_attack():
	isAttacking = true
	animated_sprite.play("ready")
	yield(animated_sprite, "animation_finished")
	attack()


func attack():
	
	if not isAttacking: # if attack was interrupted by player attack
		return
	
	animated_sprite.play("attack")
	$Attack.set_collision_mask_bit(0, true)
	yield(animated_sprite, "animation_finished")
	$Attack.set_collision_mask_bit(0, false)
	isAttacking = false


func _on_Attack_body_entered(body):
	if body.name == "Player":
		get_tree().call_group("GameState", "hurt", position)
