extends Node

var stage_num = 1
var buildmode = false
var tilemap
var cardUI
var current_stage
var player
var spikes
var score = 0

func _ready():
	pass

class CustomSorts:
	static func sort_by_x(a,b):
		if a.x < b.x:
			return true
		return false

#setter and getter for build mode
func set_buildmode(setter):
	buildmode = setter


func get_buildmode():
	return buildmode


func register_tilemap(in_tilemap):
	tilemap = in_tilemap


func register_cardUI(in_cardUI):
	cardUI = in_cardUI

func get_min_vect(v1,v2):
	v1.x = min(v1.x,v2.x)
	v1.y = min(v1.y,v2.y)
	return v1

func get_max_vect(v1,v2):
	v1.x = max(v1.x,v2.x)
	v1.y = max(v1.y,v2.y)
	return v1

func register_currentstage(stage):
	current_stage = stage

func register_player(player):
	self.player = player

func register_spikes(spikes):
	self.spikes = spikes
