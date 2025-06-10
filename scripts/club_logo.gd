extends Control

const MAIN_MENU = preload("res://scenes/MainMenu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(2.0).timeout.connect(go_to_next_scene)

func _unhandled_input(event: InputEvent) -> void:
	# If the player taps the screen then it goes to the selection menu
	if event is InputEventScreenTouch and event.is_pressed():
		go_to_next_scene()
	
	# This is for debugging on pc
	if OS.has_feature("pc"):
		if event is InputEventMouseButton and event.is_pressed():
			go_to_next_scene()

func go_to_next_scene():
	get_tree().change_scene_to_packed(MAIN_MENU)
