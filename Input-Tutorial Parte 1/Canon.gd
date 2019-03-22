extends Node2D

var posx = 0.0
var posy = 0.0
var velocity = 3

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	move_and_collide(Vector2(posx, posy))
	pass
