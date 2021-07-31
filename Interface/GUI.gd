extends MarginContainer

onready var resource_counter = $HBoxContainer/Counters/ResourceCounter
onready var hp_bar = $HBoxContainer/Bars/Bar/HealthBar

func _ready():
	add_to_group("Gui")

func update_coin_counter():
	resource_counter.update_coins()
	
func update_key_counter():
	resource_counter.update_keys()
	
func update_hp_bar():
	hp_bar.update_hp()
	
