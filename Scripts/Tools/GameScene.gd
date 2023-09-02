extends Node2D

var build_mode = false

var tilemap = Global.tilemap
var cardUI = Global.cardUI
onready var player = get_node("Player")
var cards_list = []
#where the preview for the card preset will be stored
var preview
var preview_card

func _ready():
	cardUI.connect("card_drawn", self, "_on_card_drawn")
	#hooking up detection for if a card is selected
	for c in cardUI.get_node("Hand").get_children():
		cards_list.append(c)
		
		#gets the button on each card and connects it to _on_card_clicked
		
		#the connect args are as follows 1:the signal, 2: who it's connecting to,
		#3:the func it connects to, 4:the array of args passed to the function
		c.get_node("ToolButton").connect("pressed", self, "_on_card_clicked", [c])


func _process(delta):
	#updates various node controlled by the global script
	tilemap = Global.tilemap
	#utilizes the scale of the map to make the preset follow where it should be
	var mouse_position_on_tiles = tilemap.world_to_map(get_global_mouse_position()/tilemap.scale.x) * tilemap.scale.x
	var snapped_mouse_position = tilemap.map_to_world(mouse_position_on_tiles) 
	
	var player_on_tiles = tilemap.world_to_map(player.position / tilemap.scale.x)
	
	
	#everything to be ran upon build mode
	if build_mode:
		#code to excecute when a preview exists
		if preview != null:
			preview.position = snapped_mouse_position
			if Input.is_action_just_pressed("left_click"):
				#divided by 2 to comphensate for the doubled scale
				place_preview(mouse_position_on_tiles/tilemap.scale.x)
			if Input.is_action_just_pressed("ui_cancel"):
				delete_preview()
		elif Input.is_action_just_pressed("ui_cancel"):
			enable_build_items(false)
	else:
		if tilemap.get_cellv(player_on_tiles) != -1:
			player.position.y += -20


func _on_Enter_build_mode_pressed():
	if !build_mode:
		enable_build_items(true)
	else:
		enable_build_items(false)


#passes in a boolean that will pause / unpause the nodes which get paused in build mode
func pause_nodes(enabled):
	var pausing_nodes = get_tree().get_nodes_in_group("pause_on_buildmode")
	for node in pausing_nodes:
			node.set_physics_process(!enabled)


#everything which needs to be enable/disabled upon entering/exiting build mode
func enable_build_items(enabled):
	build_mode = enabled
	pause_nodes(enabled)
	cardUI.visible = enabled
	if !enabled:
		#clears the preview
		delete_preview()


#called when the user clicks on the card (one day try to change it to a card)
func _on_card_clicked(card):
	#if there's already a preview delete the existing one
	if preview != null:
		preview.queue_free()
	#store the tilemap in the preview var and add it as a child
	preview = card.get_node("TilePreset").duplicate()
	preview.scale = tilemap.scale
	preview.modulate = Color("96ffee")
	self.add_child(preview)
	preview_card = card


func delete_preview():
	if preview != null:
		preview.queue_free()
	preview = null
	preview_card = null


func place_preview(tile_position):
	for tile_pos in preview.get_used_cells():
		tilemap.set_cellv(tile_position + tile_pos, 1)
	remove_card(preview_card)
	delete_preview()


func remove_card(card):
	if card != null:
		cards_list.erase(card)
		card.queue_free()


func _on_card_drawn():
	var c = cardUI.get_node("Hand").get_child(cards_list.size())
	cards_list.append(c)
	c.get_node("ToolButton").connect("pressed", self, "_on_card_clicked", [c])
