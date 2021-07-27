extends Control

var disableInput = false

func _input(event):
	if not disableInput:
		if event is InputEventKey and event.pressed or event is InputEventScreenTouch:
			disableInput = true
			PlayerVariables.restart()
			get_tree().call_group("GameState", "goto_scene", "res://Levels/Level1.tscn")
