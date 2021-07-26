extends MarginContainer

func update_coins():
	$Background/Label.text = str(PlayerVariables.treasure)
