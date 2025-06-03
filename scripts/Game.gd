extends Control

@onready var player_label: Label = $PlayerLabel
@onready var arrow: Sprite2D = $Arrow
@onready var time_label: Label = $Time
@onready var turn_button: Button = $TurnButton
@onready var timer: Timer = $Timer
@onready var minigame_container: Node = $MinigameContainer

const TOTAL_TIME = 30.0
var time = TOTAL_TIME
var players = []
var index = 0

func _ready() -> void:
	players = Global.players
	update_ui()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_tick)
	
func update_ui() -> void:
	player_label.text = players[index] + " turn"
	time_label.text = str(round(time))
	arrow.rotation_degrees = index * (360 / players.size())
	turn_button.visible = true
	for child in minigame_container.get_children():
		child.queue_free()

func _on_turn_button_pressed() -> void:
	turn_button.visible = false
	timer.start()
	loadMinigame()

func _on_timer_tick() -> void:
	time -= 1
	time_label.text = str(round(time))
	if time <= 0:
		eliminatePlayer()

func loadMinigame() -> void:
	var minigame = preload("res://scenes/ArithmeticMinigame.tscn").instantiate()
	minigame_container.add_child(minigame)
	minigame.connect("minigameFinished", Callable(self, "endTurn"))

func endTurn() -> void:
	timer.stop()
	nextPlayer()
	update_ui()

func eliminatePlayer() -> void:
	players.remove_at(index)
	if players.size() == 1:
		showWinner()
		return
	if index >= players.size():
		index = 0
	time = TOTAL_TIME
	update_ui()

func nextPlayer() -> void:
	index = (index + 1) % players.size()

func showWinner() -> void:
	player_label.text = "Winner: " + players[0]
	turn_button.visible = false
	timer.stop()
	for child in minigame_container.get_children():
		child.queue_free()
