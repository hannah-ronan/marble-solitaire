extends Node2D
class_name Empty

signal empty_clicked

func get_class(): 
	return "Empty"

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("empty_clicked", self)

