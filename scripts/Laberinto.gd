extends Node2D
const Theball = preload("res://scenes/Theball.tscn")
#Cuando inicie el minijuego, traemos una instancia de la pelota a la escena.
func _ready() -> void:
	var instanciapelota = Theball.instantiate()
	add_child(instanciapelota)
func _process(delta: float) -> void:
	pass
