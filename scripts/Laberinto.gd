extends Node2D
const Theball = preload("res://scenes/Theball.tscn")
signal minigameFinished
#Cuando inicie el minijuego, traemos una instancia de la pelota a la escena.
func _ready() -> void:
	var instanciapelota = Theball.instantiate()
	add_child(instanciapelota)
	
	#Si llega la señal goalReached, que ejecute onGoalReached
	instanciapelota.connect("goalReached", Callable(self, "onGoalReached"))

func onGoalReached() -> void:
	emit_signal("minigameFinished")

func _process(delta: float) -> void:
	pass
