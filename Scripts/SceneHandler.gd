extends Node

onready var current_stage = get_node("Stage" + str(Global.stage_num))
onready var tilemap = current_stage.get_node("TileMap")
onready var player = get_node("Player")
onready var hand = get_node("GUI/CardUI/Hand")
onready var buildcam = get_node("BuildCam")

var preview
var selected_card

func _ready():
	set_build_mode(true)

func _process(delta):
	var mouse_position_on_tiles = tilemap.world_to_map(current_stage.get_global_mouse_position()
	 / tilemap.scale.x) * tilemap.scale.x
	var snapped_mouse_position = tilemap.map_to_world(mouse_position_on_tiles) 
	
	var player_on_tiles = tilemap.world_to_map(player.position / tilemap.scale.x)
	#what should be run during build mode
	if Global.get_buildmode():
		if preview != null:
			preview.position = snapped_mouse_position
			if Input.is_action_just_pressed("left_click"):
				#divided by 2 to comphensate for the doubled scale
				place_preview(mouse_position_on_tiles/tilemap.scale.x)
			if Input.is_action_just_pressed("ui_cancel"):
				delete_preview()




#when a build mode button was in use

#func _build_mode_pressed():
#	set_build_mode(!Global.get_buildmode())



func pause_nodes(enabled):
	var pausing_nodes = get_tree().get_nodes_in_group("pause_on_buildmode")
	for node in pausing_nodes:
			node.set_physics_process(!enabled)


func _on_card_clicked(preset,card):
	if Global.get_buildmode():
		selected_card = card
		preview = preset.duplicate()
		preview.scale = tilemap.scale
		add_child(preview)


func set_build_mode(toggle):
	Global.set_buildmode(toggle)
	pause_nodes(toggle)
	Global.cardUI.visible = toggle
	if !toggle:
		delete_preview()
		player.camera.make_current()
	else:
		buildcam.position = player.position
		buildcam.make_current()


func delete_preview():
	if preview != null:
		preview.queue_free()
	preview = null
	selected_card = null

func delete_card(card):
	if card != null:
		card.queue_free()


func place_preview(tile_position):
	var mincorner = Vector2(99999,99999)
	var maxcorner = Vector2.ZERO
	#plays the card and makes sure it can make a valid play
	if(Global.cardUI.play_card(selected_card) != null):
		for tile_pos in preview.get_used_cells():
			mincorner = Global.get_min_vect(mincorner, tile_pos)
			maxcorner = Global.get_max_vect(maxcorner, tile_pos)
			tilemap.set_cellv(tile_position + tile_pos, 0)
			Global.current_stage.spikes.set_cellv(tile_position + tile_pos, -1)
		tilemap.update_bitmask_region(mincorner + tile_position,maxcorner + tile_position)
	#delete_card(selected_card)
	selected_card = null
	delete_preview()


