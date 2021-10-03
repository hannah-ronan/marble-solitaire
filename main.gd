extends Node
var marble_class = load("res://marble.tscn")

const right = [2,0]
const left = [-2,0]
const down = [0,2]
const up = [0,-2]
const empty = " "
const invalid = "+"
onready var marbles = $table.get_children()
onready var messagelabel = $message

	


func try_move(origin, direction):
	#origin is a set of coordinates [x,y]
	#direction is a choice of variables right, left, down, up
	#if target is not empty and a valid spot on the table, and there is a marble in
	#between the origin and the destination then move the marble
	pass

func refresh_table():
	pass
	
func _ready():
	print ("f")
	


	 
