extends Node

var lives = 3
var treasure = 0
var totalTreasure = 0
var mapPiece = false
var animation_affix = "_sword"
var disableAnimate = false

func restart():
	lives = 3
	treasure = 0
	mapPiece = false

func newLevel():
	totalTreasure += treasure
	treasure = 0
