extends Control

@onready var name_input: LineEdit = $VBoxContainer/HBoxContainer/NameInput
@onready var player_list: ItemList = $VBoxContainer/PlayerList

const MAX_PLAYERS = 10
var players = []

func _on_add_button_pressed() -> void:
	var name = name_input.text.strip_edges()
	if name == "":
		return
	if players.size() > MAX_PLAYERS:
		return
	if name in players:
		return
		
	players.append(name)
	player_list.add_item(name)
	name_input.text = ""

func _on_remove_button_pressed() -> void:
	var index = player_list.get_selected_items()
	if index.size() == 0:
		return
	var i = index[0]
	players.remove_at(i)
	player_list.remove_item(i)

func _on_start_button_pressed() -> void:
	if players.size() < 2:
		return
	Global.players = players.duplicate()
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
