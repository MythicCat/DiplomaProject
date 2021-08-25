extends Node2D

export var speed = 210

var direction = 1

onready var ball = $Area2D/Sprite
onready var explosion = $AnimatedSprite

func _ready():
	set_as_toplevel(true)
	direction = get_parent().get_parent().scale.x
	global_position = get_parent().global_position

func _process(delta):
	position.x -= speed * direction * delta
	detect_collision()
	
#func _physics_process(delta):
#	position -= transform.x * delta * direction
#	detect_collision()
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func detect_collision():
	var collider = $Area2D.get_overlapping_bodies()
	for object in collider:
		if object.name == "Player":
			get_tree().call_group("GameState", "hurt", position)
		ball.visible = false
		speed = 0
		explosion.visible = true
		$Area2D.set_collision_mask_bit(0,false)
		explosion.play("explode")
		


func _on_AnimatedSprite_animation_finished():
	if explosion.animation == "explode":
		queue_free()
