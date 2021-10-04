extends Node2D
class_name Invalid
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_class(): return "Invalid"
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		self.on_click()

func on_click():
	#when an invalid spot is clicked send a signal to game to display invalid message
	pass
