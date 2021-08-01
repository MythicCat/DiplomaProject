extends Node2D

var speed = 200

onready var ball = $Sprite

func _process(delta):
	position += transform.x * speed * delta
	detect_collision()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func detect_collision():
	var collider = $Area2D.get_overlapping_bodies()
	for object in collider:
		if object.name == "Player":
			get_tree().call_group("GameState", "hurt", position)
		ball.visible = false
		queue_free()
