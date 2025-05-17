extends Control

@onready var start: Button = $start

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/PlayerSelector/PlayerMenu.tscn")
