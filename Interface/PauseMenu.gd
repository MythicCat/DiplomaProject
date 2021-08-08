extends Control

export(float) var fade_duration = 0.3

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)
onready var optionsControls = $ColorRect/CenterContainer/TextureRect/Options
onready var mainControls = $ColorRect/CenterContainer/TextureRect/Main

func _ready():
	hide()
	mainControls.show()
	optionsControls.hide()


func open():
	show()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, # modulate alpha property of parent:modulate from 0 -> 1
			fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func close():
	get_tree().paused = false
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0,
			fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func _on_Resume_pressed():
	if not $Tween.is_active():
		close()
	


func _on_Quit_pressed():
	scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()


func _on_Options_pressed():
	optionsControls.show()
	mainControls.hide()


func _on_Tween_tween_all_completed():
	mainControls.show()
	optionsControls.hide()
