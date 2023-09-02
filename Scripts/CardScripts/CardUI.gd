extends Control

onready var manadisplay = get_node("ManaDisplay")
onready var drawpile = get_node("DrawPile")
var hand_size = 5
var perturn_mana = 3
var current_mana = 3

func _ready():
	manadisplay.text = "Mana: " + str(current_mana)
	Global.register_cardUI(self)
	#connects all cards to the click card func
	validate_hand()

func play_card(card):
	current_mana -= card.manacost
	if current_mana < 0:
		current_mana += card.manacost
		print("no more mana")
		return null
	else:
		var preset = card.get_node("Preset")
		manadisplay.text = "Mana: " + str(current_mana)
		get_node("DiscardPile").add_card(card)
		card.queue_free()
		return preset

func validate_hand():
	var hand = get_node("Hand")
	for card in hand.get_children():
		validate_card(card)

func validate_card(card):
	card.get_node("ToolButton").connect("pressed", self, "_on_card_clicked", [card.preset,card])

func discard_card(card):
	if card != null:
		#adds card to discard and delets the one in hand
		get_node("DiscardPile").add_card(card)
		card.queue_free()
		#centers the hand
		var hand = get_node("Hand")
		hand.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_WIDE)
	else:
		print("nonexistent card was attempted to be discarded")


func next_turn():
	#turns off build mode
	get_tree().current_scene.set_build_mode(false)
	#resets mana
	current_mana = perturn_mana
	manadisplay.text = "Mana: " + str(current_mana)
	
	#discards current hand and draws a new one
	for card in get_node("Hand").get_children():
		discard_card(card)
	for i in range(hand_size):
		draw_card_from_drawpile()
	#connects all the cards in hand to the click card func
	validate_hand()
	
	#ensure a card is selected before the hand is played
	get_node("CardSelect").visible = true
	get_node("Hand").visible = false


func draw_card_from_drawpile():
	var cardstring = drawpile.draw()
	if cardstring != null:
		var cardfile = load(cardstring)
		var newcard = cardfile.instance()
		#adds the new card to hand and centers the hand
		var hand = get_node("Hand")
		hand.add_child(newcard)
		hand.set_anchors_and_margins_preset(Control.PRESET_BOTTOM_WIDE)


func _on_card_clicked(preset,card):
	if Global.get_buildmode():
		var current_scene = get_tree().current_scene
		current_scene.selected_card = card
		var preview = preset.duplicate()
		preview.scale = Global.tilemap.scale
		current_scene.preview = preview
		current_scene.add_child(preview)

func _card_selected(card):
	drawpile.add_card(card)
	get_node("CardSelect").visible = false
	get_node("Hand").visible = true


func _on_NextTurn_pressed():
	next_turn()
