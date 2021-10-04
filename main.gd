extends Node
var empty_tile = load("res://empty.tscn")



const right = Vector2(22,0)
const left = Vector2(-22,0)
const down = Vector2(0,22)
const up = Vector2(0,-22)

var marbles = []
var invalids = []
onready var empties = $marbleholder.get_children()
onready var messagelabel = $message
var turn_status = "waiting"
var current_origin
var current_dest

func refresh_table():
	pass
	
func _ready():
	#try_move($table/marble5, $table/empty)
	#catalogue all the tiles in the game so that their signals can be connected
	for tile in $table.get_children():
		if tile.get_class()=="Marble":
			marbles.append(tile)	
		elif tile.get_class()=="Invalid":
			invalids.append(tile)
		else:
			empties.append(tile)
	#connect signals 
	for marb in marbles:
		marb.connect("marble_clicked",self, "marble_clicked")
	for empt in empties:
		empt.connect("empty_clicked", self, "empty_clicked")
	for inv in invalids:
		inv.connect("invalid_clicked", self,"invalid_clicked")
		
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
		#if the destination is not 2 spaces to the left, right, up or down, then the move is invalid
		valid_move = false
		$message.set_text("Invalid Move")
	
	var junk_marble_found = false
	var junk_marble
	for item in marbles:
		if item.get_class()=="Marble":
			if junk_marble_loc == item.position:
				#find the marble object that is at the location of the junk marble
				junk_marble_found = true
				junk_marble = item
				
	if valid_move==true and junk_marble_found==true:
		#deactivate the marble in between the origin and the destination
		junk_marble.active = false
		#move the old marble over into the marbleholder
		$table.remove_child(junk_marble)
		$marbleholder.add_child(junk_marble)
		#instance a new empty object where the in between marble was
		var new_empty = empty_tile.instance()
		new_empty.set_position(junk_marble_loc)
		$table.add_child(new_empty)
		#move the marble to the destination space
		origin.set_position(dest_pos)
		#move the empty to the origin space
		destination.set_position(origin_pos)
		origin.reset_texture()
		turn_status = "waiting"
	else:
		$message.set_text("Invalid Move, junk marble not found")

func marble_clicked(clicked_marb):
	if turn_status == "waiting":
		clicked_marb.toggle_texture()
		for marble in marbles:
			if marble != clicked_marb:
				marble.reset_texture()
		turn_status = "origin chosen"
		current_origin = clicked_marb
	else:
		if turn_status == "origin chosen":
			$message.set_text("please choose a destination")
			
func empty_clicked(clicked_empty):
	turn_status = "destination chosen"
	current_dest = clicked_empty
	try_move(current_origin,current_dest)
	
func invalid_clicked():
	$message.set_text("Invalid tile clicked, please try again")
