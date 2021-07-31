extends MarginContainer

func update_coins():
	$Background/CoinCount.text = str(PlayerVariables.treasure)

func update_keys():
	$Background/KeyCount.text = str(PlayerVariables.keys)
