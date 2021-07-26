extends Control

func _input(event):
	if event is InputEventKey and event.pressed or event is InputEventScreenTouch:
		PlayerVariables.restart()
		get_tree().call_group("GameState", "goto_scene", "res://Levels/Level1.tscn")
