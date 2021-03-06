extends Node
#load the empty class to be used when moving marbles
var empty_tile = load("res://empty.tscn")
#define some directions for moves
const right = Vector2(22,0)
const left = Vector2(-22,0)
const down = Vector2(0,22)
const up = Vector2(0,-22)

#create some lists to hold all the instances of marbles, empties, and invalid tiles, this makes it easy to iterate through them
var marbles = []
var invalids = []
var empties = []
#message label for printing error messages
onready var messagelabel = $message
#turn status is determined by what stage the move is at, can be waiting,origin chosen, or destination chosen
var turn_status = "waiting"
#the currently selected marble and empty used for making moves
var current_origin
var current_dest
var marble_holder_positions=[]
	
func _ready():
	#create an array of available positions in the marble holder to move junk marbles to later
	for x in 5:
		for y in 7:
			marble_holder_positions.append(Vector2(x,y))

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
		$message.set_text("Destination is too far away")
	
	var junk_marble_found = false
	var junk_marble
	for marb in marbles:
		if junk_marble_loc == marb.position and marb.active==true:
			#find the marble object that is at the location of the junk marble
			junk_marble_found = true
			junk_marble = marb
				
	if valid_move==true and junk_marble_found==true:
		#deactivate the marble in between the origin and the destination
		junk_marble.active = false
		junk_marble.set_position(marble_holder_positions.pop_front()*11) #set the position to the next available spot in marbleholder
		#move the old marble over into the marbleholder
		$table.remove_child(junk_marble)
		$marbleholder.add_child(junk_marble)
		#instance a new empty object where the in between marble was
		var new_empty = empty_tile.instance()
		new_empty.connect("empty_clicked", self, "empty_clicked")
		new_empty.set_position(junk_marble_loc)
		$table.add_child(new_empty)
		#move the marble to the destination space
		origin.set_position(dest_pos)
		#move the empty to the origin space
		destination.set_position(origin_pos)
		origin.reset_texture()
		turn_status = "waiting"
		#reset the error message
		$message.set_text("")
		#check to see if there are any valid moves left
		check_for_moves()
		
	else:
		$message.set_text("Invalid Move, junk marble not found")

func marble_clicked(clicked_marb):
	#clicked_marb is the marble object that was clicked
	if turn_status!="game over":
		#change the texture so its easy to see which marble was clicked
		clicked_marb.toggle_texture()
		for marble in marbles:
			if marble != clicked_marb:
				marble.reset_texture()
		#update turn_status so that the user can choose a destination
		turn_status = "origin chosen"
		#update current_origin so it can be used in try_move later 
		current_origin = clicked_marb

func empty_clicked(clicked_empty):
	#clicked_empty is the empty object the user clicked
	if turn_status != "game over":
		#when the user clicks an empty make sure they are in the right stage of the turn
		for marble in marbles:
			marble.reset_texture()
		if turn_status =="origin chosen":
			turn_status = "destination chosen"
			current_dest = clicked_empty
			#now that the destination and origin have been chosen, use try_move to confirm that this is a valid move and try it
			try_move(current_origin,current_dest)
		else:
			$message.set_text("please choose an origin")
		
func invalid_clicked():
	$message.set_text("Invalid tile clicked, please try again")


func _on_Button_pressed():
	#for debugging purposes only
	$message.set_text(turn_status)

func check_for_moves():
	#check to see if the player has no more moves left
	var move_found = false
	var empty_positions=[]
	var marble_positions = []
	for tile in $table.get_children():
		if tile.get_class()=="Empty":
			empty_positions.append(tile.position)
		elif tile.get_class()=="Marble" and tile.active==true:
			marble_positions.append(tile.position)	
		
	for marb in marbles:
		if move_found != true:
			if marb.active==true:
				#check to see if the current marble has any valid moves
				if marb.position+right in empty_positions and marb.position+right/2 in marble_positions:
					move_found=true
				elif marb.position+left in empty_positions and marb.position+left/2 in marble_positions:
					move_found=true
				elif marb.position+up in empty_positions and marb.position+up/2 in marble_positions:
					move_found=true
				elif marb.position+down in empty_positions and marb.position+down/2 in marble_positions:
					move_found=true
				
	if move_found != true:
		game_over()
				
func game_over():
	#called whenever there are no valid moves left
	turn_status="game over"
	var marbles_left = 0
	for marb in marbles:
		if marb.active == true:
			marbles_left+=1
	$message.set_text("game over - "+str(marbles_left)+" marbles left")
