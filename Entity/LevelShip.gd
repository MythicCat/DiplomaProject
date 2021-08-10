extends KinematicBody2D

export var next_scene : String
export var maxSpeed = 80
var sailUp = false
var motion = Vector2(0,0)
var startMoving = false
var startTime = false
const UP = Vector2(0,-1) # for move_and_slide ( -1 -> treat walls and floor differently)

func _physics_process(delta):
	
	animate()
	
	if sailUp:
		move()
		move_and_slide(motion, UP)
	

func _on_CheckForPlayer_body_entered(body):

	if !PlayerVariables.mapPiece and body == Player: # only go to next level if player found the map piece
		return
	startMoving = true
	$Sail.play("move_start")
	get_tree().call_group("GameState", "goto_scene", next_scene)


func _on_Sail_animation_finished():
	if $Sail.animation == "move_start":
		sailUp = true


func animate():
	
	$Boat.play("idle")
	
	if not sailUp and not startMoving:
		$Sail.play("idle")
		
	elif motion.x > 0:
		$Sail.play("move")


func move():
	if motion.x < maxSpeed:
		motion.x = lerp(motion.x, 90, 0.01)
