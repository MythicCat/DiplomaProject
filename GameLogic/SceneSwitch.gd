extends Node

var current_scene = null
var next_path = ""

onready var _pause_menu = $Interface/PauseMenu
onready var _main_menu = $Interface/MainMenu

func _ready():
	
	add_to_group("GameState")
	var directory = Directory.new()
	
	if directory.file_exists("user://saved_level.tscn"): # load level
		_main_menu.save_exists()
	_main_menu.show()
	
	var root = get_tree().get_root()
	add_child(ResourceLoader.load("res://Levels/MainMenuBackdrop.tscn").instance())
	current_scene = get_children()[get_child_count() -1]
	current_scene.pause_mode = PAUSE_MODE_STOP
	

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if not _main_menu.visible:
			var tree = get_tree()
			tree.paused = not tree.paused
			if tree.paused:
				_pause_menu.open()
			else:
				_pause_menu.close()
			get_tree().set_input_as_handled() # prevents input from propagating further
		else:
			_main_menu.return()


func goto_scene(path):
	
	next_path = path
	$Transition.transition()
	yield($Transition, "transitioned")
	
	if "MainMenu" in path:
		_main_menu.show()
	else:
		_main_menu.hide()
		
	call_deferred("_deferred_goto_scene", next_path)
	

func _deferred_goto_scene(path):
	
	current_scene.queue_free() # current scene safe to remove
	
	var new_scene = ResourceLoader.load(path) # load next level
	
	current_scene = new_scene.instance() # instance level
	current_scene.pause_mode = PAUSE_MODE_STOP # make pausable
		
	add_child(current_scene) # add to Game as child

	get_tree().set_current_scene(current_scene)
	
	PlayerVariables.new_level() # reset coin and key counter
	
	$Transition.transition()


func save_level():
	PlayerVariables.save_values()
	var packed_scene = PackedScene.new()
	packed_scene.pack(get_child(get_child_count() - 1))
	ResourceSaver.save("user://saved_level.tscn", packed_scene)
	$SaveStatus/LabelFade.play("show_label")
	
func load_level():
	goto_scene("user://saved_level.tscn")

func delete_save():
	var dir = Directory.new()
	dir.remove("user://saved_level.tscn")
	
	PlayerVariables.restart() # resets everything to 0
	PlayerVariables.save_values() # overwrites saved values


func new_game():
	goto_scene("res://Levels/Level1.tscn")
