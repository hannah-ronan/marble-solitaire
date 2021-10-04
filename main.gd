extends Node
var empty_tile = load("res://empty.tscn")



const right = Vector2(22,0)
const left = Vector2(-22,0)
const down = Vector2(0,22)
const up = Vector2(0,-22)

onready var marbles = $table.get_children()
onready var empties = $marbleholder.get_children()
onready var messagelabel = $message

	




func refresh_table():
	pass
	
func _ready():
	try_move($table/marble5, $table/empty)
	
func try_move(origin, destination):
	#origin is a marble object and destination is an empty object
	var dest_pos = destination.position
	var origin_pos = origin.position
	var junk_marble_loc = Vector2(0,0)
	var valid_move = true
	#find out the location of the marble in between the origin and destination
	if origin_pos+right==dest_pos:
		junk_marble_loc = origin_pos+right/2
	elif origin_pos+left==dest_pos:
		junk_marble_loc = origin_pos+left/2
	elif origin_pos+up==dest_pos:
		junk_marble_loc = origin_pos+up/2
	elif origin_pos+down==dest_pos:
		junk_marble_loc = origin_pos+down/2
	else:
		valid_move = false
		$message.set_text("Invalid Move")
	
	var junk_marble_found = false
	var junk_marble
	for item in marbles:
		print(item.get_class())
		if item.get_class()=="Marble":
			if junk_marble_loc == item.position:
				junk_marble_found = true
				junk_marble = item
				
	if valid_move==true and junk_marble_found==true:
		#deactivate the marble in between the origin and the destination
		junk_marble.active = false
		#move the old marble over into the marbleholder
		$table.remove_child(junk_marble)
		$marbleholder.add_child(junk_marble)
		#instance a new empty object where the in between marble was
		var empty = $marbleholder.get_child(1)
		empty.set_postion(junk_marble_loc)
		$table.add_child(empty)
		#move the marble to the destination space
		origin.set_position(dest_pos)
		#move the empty to the origin space
		destination.set_position(origin_pos)
	else:
		$message.set_text("Invalid Move, junk marble not found")
	
	 
