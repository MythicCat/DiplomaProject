extends Node

var save_path = "user://settings.cfg" # do not use res:// for saving
var config = ConfigFile.new()
var load_response = config.load(save_path)

func _ready():
	
	if load_response == OK:
		loadSettings()


func saveSetting(section, key, value):
	config.set_value(section, key, value)
	config.save(save_path)
	
func loadSetting(section, key, value):
	config.get_value(section, key, value)



func loadSettings():
	if not config.has_section("Sound"):
		return
	else:
		var keys = config.get_section_keys("Sound")
		for name in keys:
			var bus_index = AudioServer.get_bus_index(name)
			AudioServer.set_bus_volume_db(bus_index, config.get_value("Sound", name))
	
	if not config.has_section("Player"):
		return
	else:
		var keys = config.get_section_keys("Player")
		var values = []
		for name in keys:
			values.append(config.get_value("Player", name))
		PlayerVariables.load_values(values)
