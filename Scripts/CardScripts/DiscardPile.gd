extends Node

var pile = []

func _ready():
	pass

func add_card(card):
	pile.append(card.filename)

#used to easily look through the cards in the pile
func debug_print_pile():
	var printing_array = []
	for string in pile:
		#looks through the filename and only prints out the names of the cards
		printing_array.append(string.rsplit("/",true,1)[1].rsplit(".",true,1)[0])
	print(printing_array)
