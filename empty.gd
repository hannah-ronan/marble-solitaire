extends Node2D
class_name Empty
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func get_class(): return "Empty"


func _ready():
	pass # Replace with function body.

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		self.on_click()

func on_click():
	#when an empty spot is clicked send a signal to game to display empty message
	pass
