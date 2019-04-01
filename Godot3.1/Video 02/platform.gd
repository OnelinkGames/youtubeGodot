extends KinematicBody2D

var SPEED = 100
var motion = Vector2()
var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout", self, "timeIsOver")
	pass # Replace with function body.

func timeIsOver():
	if dir == 1:
		dir = -1
	else:
		dir = 1
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position.x += SPEED * dir * delta
	pass
