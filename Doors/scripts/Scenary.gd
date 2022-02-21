extends Node2D

# variables
var roof : TileMap
var roof_area : Area2D
var house_area : Area2D
var chimney : TileMap
var house : TileMap
var animation : Tween
var is_in_house : bool = false
var character : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	# start nodes
	roof = $Roof
	roof_area = $Roof/RoofArea
	house_area = $Roof/HouseArea
	chimney = $Chimney
	house = $House
	animation = $Roof/Tween
	
	# connections
	roof_area.connect("body_entered", self, "invisible_roof")
	roof_area.connect("body_exited", self, "visible_roof")
	house_area.connect("body_entered", self, "clear_roof")
	house_area.connect("body_exited", self, "restore_roof")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# make the roof visible again
func visible_roof(body):
	if (body.is_in_group("character") && is_in_house == false):
		# check array
		if (character.size() == 1):
			# make the roof visible
			roof.modulate = Color(1, 1, 1, 1)
			chimney.modulate = Color(1, 1, 1, 1)
		
		# remove the character
		var charIndex = character.find(body)
		character.remove(charIndex)

# make the roof transparent
func invisible_roof(body):
	if (body.is_in_group("character")  && is_in_house == false):
		# check array
		if (character.size() == 0):
			# make the roof transparent
			roof.modulate = Color(1, 1, 1, .5)
			chimney.modulate = Color(1, 1, 1, .5)
		
		# add the character
		character.append(body)
		
# make the roof invisible
func clear_roof(body):
	if (body.is_in_group("character")):
		# check array
		if (character.size() == 0):
			# modulate the roof and chimney
			roof.modulate = Color(1, 1, 1, 0)
			chimney.modulate = Color(1, 1, 1, 0)
			is_in_house = true
		
		# adjust the z_index
		y_sort(body, false)
		
		# add the character
		character.append(body)

# restore the roof state
func restore_roof(body):
	if (body.is_in_group("character")):
		# check array
		if (character.size() == 1):
			# modulate the roof and chimney
			roof.modulate = Color(1, 1, 1, 1)
			chimney.modulate = Color(1, 1, 1, 1)
			is_in_house = false
		
		# adjust the z_index
		y_sort(body, true)
		
		# remove the character
		var charIndex = character.find(body)
		character.remove(charIndex)

# adjust the tile set z index
func y_sort(char_ref, sort):
	# sort them
	if (sort):
		char_ref.z_index = 1
	else:
		char_ref.z_index = 3
