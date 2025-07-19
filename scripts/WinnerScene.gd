extends Control

var nameWinner = Global.winner["name"]
var skinWinner = Global.winner["sprite"]
@onready var name_winner: Label = $VBoxContainer/NameWinner
@onready var sprite_winner: Sprite2D = $VBoxContainer/SpriteWinner
@onready var winner_sound: AudioStreamPlayer = $WinnerSound


func _ready() -> void:
	sprite_winner.frame = skinWinner
	name_winner.text = nameWinner + "!"
	name_winner.modulate.a = 0
	sprite_winner.modulate.a = 0
	winner_sound.play()
	
	await get_tree().create_timer(2.0).timeout
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(name_winner,"modulate:a", 1, 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(sprite_winner,"modulate:a", 1, 4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _on_restart_button_up() -> void:
	Global.players.clear()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
