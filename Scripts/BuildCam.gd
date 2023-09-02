extends Camera2D

export var scroll_speed = 600

func _ready():
	pass

func _physics_process(delta):
	if Global.buildmode:
		var move_dir = Vector2.ZERO
		move_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		move_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		move_dir = move_dir.normalized()
		position += move_dir * scroll_speed * delta
