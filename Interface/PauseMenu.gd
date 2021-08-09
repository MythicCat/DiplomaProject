extends Control

export(float) var fade_duration = 0.3

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count() - 1)
onready var optionsControls = $ColorRect/CenterContainer/TextureRect/Options
onready var mainControls = $ColorRect/CenterContainer/TextureRect/Main

func _ready():
	_get_volume_data()
	hide()
	mainControls.show()
	optionsControls.hide()


func open():
	show()
	$Tween.interpolate_property(self, "modulate:a", 0.0, 1.0, # modulate alpha property of parent:modulate from 0 -> 1
			fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func close():
	_save_settings()
	get_tree().paused = false
	$Tween.interpolate_property(self, "modulate:a", 1.0, 0.0,
			fade_duration, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
# BUTTON FUNCTIONS

func _on_Resume_pressed():
	if not $Tween.is_active():
		close()


func _on_Quit_pressed():
	get_tree().call_group("GameState", "save_level")
	scene_root.notification(NOTIFICATION_WM_QUIT_REQUEST)
	get_tree().quit()


func _on_Options_pressed():
	optionsControls.show()
	mainControls.hide()


func _save_settings():
	ConfigSystem.saveSetting("Sound", "Master", optionsControls.get_child(1).value)
	ConfigSystem.saveSetting("Sound", "Music", optionsControls.get_child(3).value)
	ConfigSystem.saveSetting("Sound", "SFX", optionsControls.get_child(5).value)


func _get_volume_data():
	for i in range(0, AudioServer.bus_count):
		var bus_volume = AudioServer.get_bus_volume_db(i)
		var bus_name = AudioServer.get_bus_name(i)
		get_node("ColorRect/CenterContainer/TextureRect/Options/" + bus_name + "Slider").value = bus_volume
		pass


func _on_Tween_tween_all_completed():
	mainControls.show()
	optionsControls.hide()

# SLIDER FUNCTIONS

func _on_MasterSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	if value == -20:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_MusicSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	if value == -20:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)


func _on_SFXSlider_value_changed(value):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, value)
	
	if value == -20:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
