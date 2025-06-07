extends Node2D

var dragging = false
var offset = Vector2(0,0)
var touchTile = false

signal goalReached

func _process(delta: float) -> void:
	#Caso para arreglar la situacion en que el jugador no puede atravesar paredes mientras mantiene click
	if touchTile:
		var escenapadre = get_parent()
		global_position = escenapadre.get_node("marker2d").position
		dragging = false
	else:
		#Si esta siendo sujetada, actualizar la posicion de la pelota por la del mouse (dedo)
		if dragging == true:
			global_position = get_global_mouse_position()
			
	#devolverlo a false para poder agarrar de vuelta a la pelota (si no siempre entra en touchTile verdadero)
	touchTile = false
	
#al mantener apretado
func _on_button_button_down() -> void:
	dragging = true
	

#al soltar
func _on_button_button_up() -> void:
	dragging = false
	

#Si detecta el tilemap (O salida)
func _on_area_2d_body_entered(body: Node2D) -> void:
	#global_position = Vector2(1,127)
	#Quiero que si el body que toca es un tileMapLayer, que analice de que ID se trata.
	#uso de get_cell_source_id (metodo de TileMapLayer)
	touchTile = true
	if body.is_class("TileMapLayer"):
		var escenapadre = get_parent()
		global_position = escenapadre.get_node("marker2d").position
	


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "Salida":
		emit_signal("goalReached")
