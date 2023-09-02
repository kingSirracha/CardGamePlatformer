extends Node

onready var discard_pile = get_parent().get_node("DiscardPile")
var pile = ["res://Scenes/Cards/Block.tscn","res://Scenes/Cards/Platform.tscn","res://Scenes/Cards/Platform.tscn"]

func _ready():
	pass

func draw():
	if pile.size() == 0:
		grab_cards_in_discard()
	if pile.size() != 0:
		return pile.pop_back()
	else:
		print("no more cards")

func grab_cards_in_discard():
	pile.append_array(discard_pile.pile)
	pile.shuffle()
	discard_pile.pile = []

#takes in a card node and adds the file string to the draw pile array
func add_card(card : Node):
	pile.append(card.filename)

#used to easily look at the cards in the pile
func debug_print_pile():
	var printing_array = []
	for string in pile:
		#looks through the filename and only prints out the names of the cards
		printing_array.append(string.rsplit("/",true,1)[1].rsplit(".",true,1)[0])
	print(printing_array)
