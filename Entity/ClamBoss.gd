extends KinematicBody2D

const pearl = preload("res://Hazards/Pearl.tscn")


var step = 0
var radius = 10
var ready = true
var isShooting = false

export var spawn_point_count = 6
export var shoot_timer_seconds = 3
export var arc_points = Vector2(-180, -90)


func _ready(): 
	
	step = abs(arc_points.x - arc_points.y) / spawn_point_count

	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(deg2rad(arc_points.x + (step * i+1)))
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		$FiringPoint.add_child(spawn_point)
	
	$ShootTimer.start(shoot_timer_seconds)

func _physics_process(delta):
	if not isShooting:
		$AnimatedSprite.play("idle")

func shoot():
	isShooting = true
	$AnimatedSprite.play("shoot")
	yield($AnimatedSprite, "animation_finished")
	for sp in $FiringPoint.get_children():
		var bullet = pearl.instance()
		sp.add_child(pearl.instance())
		bullet.position = sp.global_position
		bullet.rotation = sp.global_rotation
	isShooting = false



func _on_ShootTimer_timeout():
	shoot()
