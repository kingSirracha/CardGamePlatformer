extends HBoxContainer

export var cardchoices = 3
onready var card_pool = load("res://Scenes/Card_Pool.tscn").instance()

func _ready():
	set_selection()

func connect_cards():
	for card in get_children():
		card.get_node("ToolButton").connect("pressed",get_parent(),"_card_selected",[card])
		card.get_node("ToolButton").connect("pressed",self,"set_selection")

#called upon a card being selected
#used to reset the options in the card select
func set_selection():
	#remove existing children
	for child in get_children():
		child.queue_free()
	
	for n in range(cardchoices):
		var card = load(card_pool.get_card()).instance()
		add_child(card)
	
	connect_cards()

