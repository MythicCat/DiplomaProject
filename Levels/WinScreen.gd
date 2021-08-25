extends Control

var disableInput = false


func _ready():
	$Score.text = PlayerVariables.total_treasure


func _input(event):
	if not disableInput:
		if event is InputEventKey and event.pressed or event is InputEventScreenTouch:
			disableInput = true
			PlayerVariables.restart()
			get_tree().call_group("GameState", "goto_scene", "res://Levels/MainMenuBackdrop.tscn")
			get_tree().call_group("GameState", "delete_save")
