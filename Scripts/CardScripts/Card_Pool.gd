extends Node

var cards = [
	"res://Scenes/Cards/Block.tscn",
	"res://Scenes/Cards/Platform.tscn"
	]

func get_card():
	return cards[rand_range(0,cards.size())]

func _ready():
	pass
