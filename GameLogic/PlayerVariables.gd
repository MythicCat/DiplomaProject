extends Node

const MAX_HP = 3

var lives = 3
var treasure = 0
var total_treasure = 0
var keys = 0
var mapPiece = false
var disableAnimate = false

func _ready():
	pass

func restart():
	lives = 3
	treasure = 0
	total_treasure = 0
	keys = 0
	mapPiece = false
	disableAnimate = false

func newLevel():
	total_treasure += treasure
	treasure = 0

func is_full_hp() -> bool:
	if lives >= MAX_HP:
		return true
	else:
		return false

func save_values():
	ConfigSystem.saveSetting("Player", "lives", lives)
	ConfigSystem.saveSetting("Player", "treasure", treasure)
	ConfigSystem.saveSetting("Player", "total_treasure", total_treasure)
	ConfigSystem.saveSetting("Player", "keys", keys)
	ConfigSystem.saveSetting("Player", "mapPiece", mapPiece)


func load_values(value_array):
	lives = value_array[0]
	treasure = value_array[1]
	total_treasure = value_array[2]
	keys = value_array[3]
	mapPiece = value_array[4]
