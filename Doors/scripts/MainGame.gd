extends Node2D

# variables
var scenary: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# define nodes
	scenary = $Scenary
	
	""" move house to y sort
	var house = scenary.find_node("House")
	scenary.remove_child(house)
	$YSort.add_child_below_node($YSort, house)
	print(print_tree())
	"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
