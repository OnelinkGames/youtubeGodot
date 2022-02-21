extends Node2D

# variables
var animation : AnimationPlayer
var collision : CollisionShape2D
var area : Area2D
var area_collision : CollisionShape2D
var character : KinematicBody2D
var is_door_opened : bool = false
var is_on_door : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# start nodes
	animation = $AnimationPlayer
	collision = $Collision/CollisionShape2D
	area = $DoorActivate
	area_collision = $DoorActivate/CollisionShape2D
	
	# connections
	area.connect("body_entered", self, "on_door")
	area.connect("body_exited", self, "out_door")
	animation.connect("animation_finished", self, "remove_collision")
	
	# animation
	animation.play("closed")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# open the door
	open_door()

# function to open the door
func open_door():
	if (is_door_opened == false && is_on_door == true):
		if (character.direction == Vector2(0, -1) && Input.is_action_just_pressed(character.action)):
			animation.play("opening")
			is_door_opened = true

# check if the character is in front of the door
func on_door(body):
	if (body.is_in_group("character")):
		character = body
		is_on_door = true

# check if the character is not anymore in the front of the door
func out_door(body):
	if (body.is_in_group("character")):
		character = null
		is_on_door = false

# remove the collision from the door
func remove_collision(anim):
	if (anim == "opening"):
		animation.play("opened")
		collision.disabled = true
		area_collision.disabled = true
