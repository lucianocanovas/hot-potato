extends Control

@onready var name_input: LineEdit = $VBoxContainer/HBoxContainer/NameInput
@onready var player_list: ItemList = $VBoxContainer/PlayerList
const PLAYER = preload("res://scenes/Player.tscn")
const MAX_PLAYERS = 10
var players = []
var instancePlayer
func _on_add_button_pressed() -> void:
	var name = name_input.text.strip_edges()
	if name == "":
		return
	if players.size() > MAX_PLAYERS:
		return
	if name in players:
		return
	
	#Instanciamiento del Player
	var rng = RandomNumberGenerator.new()
	var numberSkin = rng.randf_range(0,5)
	instancePlayer = PLAYER.instantiate()
	add_child(instancePlayer) #para que pueda correr el programa
	var label = instancePlayer.get_node("Name")
	#print("aaa",label)  # debería imprimir <Label#...> si lo encontró
	instancePlayer.namePlayer.text = name
	instancePlayer.skin.frame = numberSkin
	
	players.append(instancePlayer)
	#print(players)
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
	#print(players)
	#Global.players = players.duplicate()
	for player in players:
		var player_data = {
			"name": player.namePlayer.text,
			"skin": player.skin.frame,
			"animation": player.animated_sprite_2d
		}
		Global.players.append(player_data)
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
