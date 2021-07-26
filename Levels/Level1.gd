extends Node2D

var coins = 0

func _ready():
	add_to_group("GameState")
	PlayerVariables.mapPiece = false
	PlayerVariables.newLevel()
	get_tree().call_group("Gui", "update_hp_bar")
	
func hurt(enemyPosition : Vector2):
	PlayerVariables.lives -= 1
	$Player.hurt(enemyPosition)
	print(PlayerVariables.lives)
	if PlayerVariables.lives == 0:
		end_game()

func end_game():
	get_tree().call_group("GameState", "goto_scene", "res://Levels/GameOver.tscn")
