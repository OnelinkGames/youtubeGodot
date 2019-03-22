extends Node2D

var velocity = 5
var finalPos = Vector2()
var canon = preload("res://Canon.tscn")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		rotate(0.1)
	elif Input.is_action_pressed("ui_left"):
		rotate(-0.1)
	
	var xpos = cos(rotation)
	var ypos = sin(rotation)
	finalPos = Vector2(xpos, ypos)
	
	if Input.is_action_just_pressed("ui_accept"):
		var ball = canon.instance()
		add_child(ball)
		ball.posx = finalPos.x * velocity
		ball.posy = finalPos.y * velocity
	pass
