extends Control

@onready var player_label: Label = $CanvasLayer/PlayerLabel
@onready var players_container: Node2D = $PlayersContainer
@onready var arrow: Sprite2D = $Arrow
@onready var time_label: Label = $CanvasLayer/Time
@onready var turn_button: Button = $CanvasLayer/TurnButton
@onready var timer: Timer = $Timer
@onready var minigame_container: Node = $MinigameContainer
@onready var bomb: TextureRect = $Bomb

const TOTAL_TIME = 30.0
const RAD = 200
var time = TOTAL_TIME
var players = []
var playersInfo
var index = 0

var angle = 0
var firstTime = true
var player_eliminated = false
const PLAYER = preload("res://scenes/Player.tscn")
var deathPlayers = 0
func _ready() -> void:
	playersInfo = Global.players
	#reconstruimos los jugadores
	for data in playersInfo:
		var instance = PLAYER.instantiate()
		players_container.add_child(instance)
		instance.namePlayer.text = data["name"]
		instance.skin.frame = data["skin"]
		print(instance.animated_sprite_2d)
		players.append(instance)
		print("///info///")
		#print(players)
		#print(playersInfo)
	update_ui()
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_tick)
	
func update_ui() -> void:
	while players[index].isDead:
		nextPlayer()
	#Modificaciones debido a que players ahora guarda instancias de Player
	player_label.text = players[index].namePlayer.text + " turn"
	time_label.text = "Time: " + str(round(time))
	#Solucion que se me viene a la mente con el tema de la flecha;
	#Siempre empezar de 0, y sumarle la rotacion hasta que coincida con el jugador 
	arrow.rotation = deg_to_rad(0)
	var contAux = 0
	while players[contAux] != players[index]:
		arrow.rotation += deg_to_rad(360 / players.size())
		contAux += 1
	#if player_eliminated:
		#arrow.rotation = deg_to_rad(0)
		#var contAux = 0
		#while players[contAux] != players[index]:
			#arrow.rotation += deg_to_rad(360 / players.size())
			#contAux += 1
		#player_eliminated = false
	#else:
		#if !(firstTime):
		#
			#angle = deg_to_rad(360 / players.size())
			#print("el angulo")
			#print(angle)
			#arrow.rotation += angle
			#print(arrow.rotation)
		#else:
			#firstTime = false
	turn_button.visible = true
	showPlayers()
	for child in minigame_container.get_children():
		child.queue_free()
	bomb.visible = true
	arrow.visible = true
	players_container.visible = true

func _on_turn_button_pressed() -> void:
	turn_button.visible = false
	timer.start()
	loadMinigame()

func _on_timer_tick() -> void:
	time -= 1
	time_label.text = "Time: " + str(round(time))
	if time <= 0:
		eliminatePlayer()

func loadMinigame() -> void:
	#hacemos invisibles los nombres,la bomba y la flecha
	bomb.visible = false
	arrow.visible = false
	players_container.visible = false
	#guardar las escenas de juegos en un array
	var arrayMinigames = ["res://scenes/ArithmeticMinigame.tscn","res://scenes/Laberinto.tscn"]
	#Alguna funcion que elija al azar 
	var rng = RandomNumberGenerator.new()
	var minigameChoosed = rng.randf_range(0, len(arrayMinigames))
	print(arrayMinigames[minigameChoosed])
	var minigame = load(arrayMinigames[minigameChoosed]).instantiate()
	minigame_container.add_child(minigame)
	minigame.connect("minigameFinished", Callable(self, "endTurn"))


func endTurn() -> void:
	timer.stop()
	nextPlayer()
	update_ui()

func eliminatePlayer() -> void:
	player_eliminated = true
	players[index].isDead = true
	deathPlayers += 1
	index += 1
	#players.remove_at(index)
	if (players.size() - 1) == deathPlayers:
		showWinner()
		return
	if index >= players.size():
		index = 0
	time = TOTAL_TIME
	update_ui()

func nextPlayer() -> void:
	index = (index + 1) % players.size()
	while players[index].isDead:
		index = (index + 1) % players.size()

func showWinner() -> void:
	index = 0
	while players[index].isDead:
		index += 1
	player_label.text = "Winner: " + players[index].namePlayer.text
	turn_button.visible = false
	timer.stop()
	for child in minigame_container.get_children():
		child.queue_free()

func showPlayers() -> void:
	for child in players_container.get_children():
		#child.queue_free()
		players_container.remove_child(child)
	for i in players.size():
		var player = players[i]
		if player.isDead:
			player.animated_sprite_2d.play("quemado")
			player.animated_sprite_2d.visible = true
			player.skin.visible = false
		var angle = deg_to_rad((360/players.size()) * i)
		var pos = Vector2(cos(angle), sin(angle)) * RAD
		#var label = Label.new()
		#label.text = playerName
		player.namePlayer.add_theme_font_size_override("font_size", 32)
		#player.set_position(pos - Vector2(player.get_minimum_size().x / 2, player.get_minimum_size().y / 2))
		print("///MAS INFO///")
		print(player.namePlayer.text)
		print(player.skin.texture)
		
		
		player.position = pos
		
		player.visible = true
		players_container.add_child(player)
		
		
func getPlayerLabel(name: String) -> Label:
	var arrayLabelPlayers = players_container.get_children()
	for child in arrayLabelPlayers:
		if child.text == name:
			return child		
	return null
