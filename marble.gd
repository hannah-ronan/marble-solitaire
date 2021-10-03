extends Node2D
var marble = preload("res://marble.png")
var marble_clicked = preload("res://marble_clicked.png")
class Marble:
	var active = true
	func move(direction):
		pass
	
func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		#when the mouse clicks the marble
		on_click()

func on_click():
	$Area2D/Sprite.set_texture(marble_clicked)
