extends Node

const MAX_HP = 3

var lives = 15
var treasure = 0
var totalTreasure = 0
var keys = 0
var mapPiece = false
var disableAnimate = false

func restart():
	lives = 3
	treasure = 0
	mapPiece = false

func newLevel():
	totalTreasure += treasure
	treasure = 0

func is_full_hp() -> bool:
	if lives >= MAX_HP:
		return true
	else:
		return false
