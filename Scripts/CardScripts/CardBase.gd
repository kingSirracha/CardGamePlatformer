extends Control

export(int) var manacost = 1
export(String) var card_type = "build"

onready var preset = get_node("Preset")
onready var manadisplay = get_node("ManaDisplay")

func _ready():
	on_ready()

func on_ready():
	manadisplay.text = str(manacost)

func on_card_played():
	pass


func on_card_discarded():
	pass


func on_card_drawn():
	pass

