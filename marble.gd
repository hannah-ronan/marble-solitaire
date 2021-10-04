extends Node2D
class_name Marble
var active = true
var marble = preload("res://marble.png")
var marble_clicked = preload("res://marble_clicked.png")

	
func get_class():
	 return "Marble"
	
func on_click():
	if $Area2D/Sprite.texture == marble:
		$Area2D/Sprite.set_texture(marble_clicked)
	else:
		$Area2D/Sprite.set_texture(marble)

func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		#when the mouse clicks the marble
		self.on_click()

