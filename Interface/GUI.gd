extends MarginContainer

onready var coin_counter = $HBoxContainer/Counters/CoinCounter
onready var hp_bar = $HBoxContainer/Bars/Bar/HealthBar

func _ready():
	add_to_group("Gui")

func update_coin_counter():
	coin_counter.update_coins()
	
func update_hp_bar():
	hp_bar.update_hp()
	
