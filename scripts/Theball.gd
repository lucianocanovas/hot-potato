extends Node2D

var dragging = false
var offset = Vector2(0,0)


func _process(delta: float) -> void:
	#Si esta siendo sujetada, actualizar la posicion de la pelota por la del mouse (dedo)
	if dragging == true:
		global_position = get_global_mouse_position()

#al mantener apretado
func _on_button_button_down() -> void:
	dragging = true
	

#al soltar
func _on_button_button_up() -> void:
	dragging = false
	

#Si detecta el tilemap (O salida)
func _on_area_2d_body_entered(body: Node2D) -> void:
	#global_position = Vector2(1,127)
	#print(body)
	var escenapadre = get_parent()
	global_position = escenapadre.get_node("marker2d").position
