extends Node2D
class_name Invalid

signal invalid_clicked

func get_class(): 
	return "Invalid"

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("invalid_clicked")

