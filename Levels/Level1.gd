extends Node2D


func _ready():
	add_to_group("GameState")
	force_update()
	$AudioStreamPlayer.play()
	
func hurt(enemyPosition : Vector2, knockback_multiplier = 1):
	if $Player.isImmune:
		return
	PlayerVariables.lives -= 1
	$Player.hurt(enemyPosition, knockback_multiplier)
	print(PlayerVariables.lives)
	if PlayerVariables.lives <= 0:
		end_game()

func end_game():
	get_tree().call_group("GameState", "goto_scene", "res://Levels/GameOver.tscn")
	

func force_update():
	get_tree().call_group("Gui", "update_coin_counter")
	get_tree().call_group("Gui", "update_key_counter")
	get_tree().call_group("Gui", "update_hp_bar")
