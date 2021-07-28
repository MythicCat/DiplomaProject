extends Position2D

const VELOCITY = 300.0
const Sword = preload("res://GameObjects/Sword.tscn")
var direction

func throw(flipped):
		
	if get_parent().get_parent().animAffix == "":
		return false
		
	var sword = Sword.instance()
	
	if flipped:
		direction = -1
		sword.get_child(0).flip_h = true
	else:
		direction = 1
	
	sword.global_position = global_position
	sword.linear_velocity = Vector2(direction * VELOCITY, -90)
	
	sword.set_as_toplevel(true)
	add_child(sword)
	return true
