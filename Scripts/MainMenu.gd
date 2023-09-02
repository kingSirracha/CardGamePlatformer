extends Control


func _ready():
	pass


func _on_Start_pressed():
	get_tree().change_scene("res://Scenes/SceneHandler.tscn")


func _on_Exit_pressed():
	get_tree().quit()
