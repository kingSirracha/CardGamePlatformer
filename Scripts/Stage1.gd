extends "res://Scripts/StageBase.gd"


func _ready():
	Global.register_tilemap(get_node("TileMap"))
	Global.register_currentstage(self)


func _on_Spikes_area_entered(area):
	print("ouch")


func _on_Spikes_body_entered(body):
	if body == Global.player:
		Global.player.just_died()

#called when the player touches the goal
func _on_GoalPost_body_entered(body):
	if body == Global.player:
		Global.score += 1
		print(Global.score)
		#place spikes
		place_spikes(int((Global.score +1)/ 1.25))
		shift_goal()
		get_tree().current_scene.set_build_mode(true)

#called whenever the goal is touched to move it to another locaion
func shift_goal():
	spawnpoint.position = goalpost.position + Vector2(0,-22)
	Global.player.position = spawnpoint.position
	var player_tilepos = tilemap.world_to_map(Global.player.position / tilemap.scale.x).x
	var tiles = get_valid_tiles()
	var goal_tile = tilemap.world_to_map(goalpost.position / tilemap.scale.x)
	tiles.erase(goal_tile)
	if tiles.size() > 0:
		#sorts the tiles by x value
		tiles.sort_custom(Global.CustomSorts,"sort_by_x")
		#get the edge tiles
		var mintile = tiles.front().x
		var maxtile = tiles.back().x
		#picks the edge tile furthest from the player
		if (player_tilepos - mintile) * -1 < player_tilepos - maxtile:
			goalpost.set_position(tilemap.map_to_world(tiles.front()) * tilemap.scale.x + Vector2(24,0)) 
		else:
			goalpost.set_position(tilemap.map_to_world(tiles.back()) * tilemap.scale.x + Vector2(24,0))
	else:
		#what happens when there are no valid tiles
		#get all tiles and sort by x
		tiles = tilemap.get_used_cells()
		tiles.erase(goal_tile)
		tiles.sort_custom(Global.CustomSorts,"sort_by_x")
		#get the edge tiles again
		var mintile = tiles.front().x
		var maxtile = tiles.back().x
		#picks the edge tile furthest from the player (this time a tile to the side of them)
		#this modified version will add a tile at a map edge
		if (player_tilepos - mintile) * -1 < player_tilepos - maxtile:
			goalpost.set_position(tilemap.map_to_world(tiles.front() + Vector2(-1,0)) * tilemap.scale.x + Vector2(24,0)) 
			tilemap.set_cellv(tiles.front() + Vector2(-1,0),0)
			tilemap.update_bitmask_area(tiles.front() + Vector2(-1,0))
		else:
			goalpost.set_position(tilemap.map_to_world(tiles.back() + Vector2(1,0)) * tilemap.scale.x + Vector2(24,0))
			tilemap.set_cellv(tiles.back() + Vector2(1,0),0)
			tilemap.update_bitmask_area(tiles.back() + Vector2(1,0))

func place_spikes(spike_num):
	var tiles = get_valid_tiles()
	var goal_tile = tilemap.world_to_map(goalpost.position / tilemap.scale.x)
	# removes the goal tile
	tiles.erase(goal_tile)
	tiles.shuffle()
	for i in range(spike_num):
		if i < tiles.size():
			spikes.set_cellv(tiles[i] + Vector2(0,-1),0)

func valid_goal_pos(tile : Vector2):
	if spikes.get_cellv(tile + Vector2(0,-1)) != -1:
		return false
	if tilemap.get_cellv(tile + Vector2(0,-1)) != -1:
		return false
	return true


func get_valid_tiles():
	var tiles = tilemap.get_used_cells()
	var tileblacklist = []
	for tile in tiles:
		if !valid_goal_pos(tile):
			tileblacklist.append(tile)
	for tile in tileblacklist:
		tiles.erase(tile)
	return tiles
