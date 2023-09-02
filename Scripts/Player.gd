extends KinematicBody2D

#gravity variables
export var base_gravity = 44

#movement variables
var velocity = Vector2.ZERO
export var speed = Vector2(400,1300)
var move_dir = Vector2.ZERO

#giving the timer nodes vars
onready var air_buffer = get_node("Air_buffer")
onready var cyote_time = get_node("Cyote_time")
onready var sprite = get_node("PlayerSprite")
onready var camera = get_node("Camera2D")
onready var tilemap = Global.tilemap
#getting respawn location
onready var spawnpoint = get_parent().get_node("Stage" + str(Global.stage_num)).get_node("SpawnPoint")

func _ready():
	Global.register_player(self)
	position = spawnpoint.position


func _physics_process(delta):
	var position_on_tiles = tilemap.world_to_map(position / tilemap.scale.x)
	var gravity
	#faster fall when moving slower
	if velocity.y < 250 && velocity.y > -250:
		gravity = base_gravity * 1.4
	else:
		gravity = base_gravity
		#detects if the player has fallen out of the map
		if position.y > 1000:
			just_died()
	#holding jump means higher jump height
	if Input.is_action_pressed("jump") && velocity.y < -450:
		gravity = base_gravity * 0.3
	#making gravity affect the player
	velocity.y += gravity
	velocity.y = min(velocity.y, speed.y)
	
	#jumping code
	if Input.is_action_just_pressed("jump"):
		air_buffer.start()
	
	if is_jump_valid():
		velocity.y = -620
		cyote_time.stop()
	
	#input to movement
	move_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = move_dir.x * speed.x
	
	#turning the velocity into movement
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	#move up until not inside of a tile
	while tilemap.get_cellv(position_on_tiles) != -1:
		position.y -= 8
		position_on_tiles = tilemap.world_to_map(position / tilemap.scale.x)
	
	#animation shiz
	
	#facing left, right, or idling
	if velocity.x < 0:
		sprite.playing = true
		sprite.flip_h = false
	elif velocity.x > 0:
		sprite.playing = true
		sprite.flip_h = true
	else:
		sprite.playing = false
		sprite.frame = 0
	
	#jumping animation
	if !is_on_floor():
		sprite.playing = false
		sprite.frame = 1
	
	
	
	#collision debuging
	
#	print("cel " + str(is_on_ceiling()))
#	print("flo " + str(is_on_floor()))
#	print("wal " + str(is_on_wall()))


func just_died():
	position = spawnpoint.position



func is_jump_valid():
	if is_on_floor():
		if air_buffer.time_left > 0:
			return true
		cyote_time.start()
	
	if cyote_time.time_left > 0 && Input.is_action_just_pressed("jump"):
		return true
	
	return false



func _on_Air_buffer_timeout():
	air_buffer.stop()


func _on_Cyote_time_timeout():
	cyote_time.stop()


func _on_AmStuck_area_entered(area):
	position.y += -20
