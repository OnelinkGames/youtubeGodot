extends Node2D

#Vars from Brick
export var direction = ""
export var object_name = ""
export var velocity = 0

#Sound Vars
var sound = false #Se o som irá mudar de volume ou não.
var sound_min = -20 #Minimo do som, quase inaudivel.
var other_object #Other object for calc
var sound_area #Area of the sound

func _ready():
	#Connect the Hit Area
	$StaticBody2D/HitArea.connect("area_entered", self, "areaEntered")
	#Connect the Sound Area
	$StaticBody2D/SoundArea.connect("body_entered", self, "bodyEntered")
	$StaticBody2D/SoundArea.connect("body_exited", self, "bodyExited")
	#Connect the ProgressBar
	$ProgressBar.connect("value_changed", self, "valueChanged")
	#Connect the Shoot Particle
	$StaticBody2D/Shoot.connect("myobject", self, "brickShoot")
	#Make the sound inaudible
	$StaticBody2D/SoundArea/ShootSound.set_volume_db(-80)
	#Starts the sound_area
	sound_area = $StaticBody2D/SoundArea/CollisionShape2D.shape.radius
	#Plays the initial animations
	$StaticBody2D/AnimationPlayer.play("idle")
	#Set the new name of Shoot
	$StaticBody2D/Shoot.object_name = object_name
	
	#Change the Rotation
	if direction == "right":
		$StaticBody2D.rotation_degrees = 90
	elif direction == "left":
		$StaticBody2D.rotation_degrees = 270
	elif direction == "up":
		$StaticBody2D.rotation_degrees = 0
	elif direction == "down":
		$StaticBody2D.rotation_degrees = 180
	pass

#All the Time
func _process(delta):
	#if the sound var is true, the sound play
	if sound == true:
		#Calculates the distance between player and brick
		var distance = other_object.get_global_position().distance_to($StaticBody2D.get_global_position())
		#Calculates the min sound and the max (3 rule)
		var audiosound = (distance * sound_min) / sound_area
		#Change the volume
		$StaticBody2D/SoundArea/ShootSound.set_volume_db(audiosound)
	pass

#When the player enters on area
func bodyEntered(body):
	if body.is_in_group("character"):
		#Creates the object reference.
		other_object = body
		#Changes the var sound to true for play the sound.
		sound = true

#When the players exit the area
func bodyExited(body):
	if body.is_in_group("character"):
		#Erase the other object
		other_object = null
		#Decrease the sound until it is inaudible
		$StaticBody2D/SoundArea/ShootSound.set_volume_db(-80)
		#MChange the var to false, stops the sound.
		sound = false

#For the Brick to Shoot
func brickShoot(obj):
	#Add the Child
	add_child(obj)
	
	#Calculate the Object position
	if direction == "right":
		obj.global_position = global_position + Vector2(40, 0)
		obj.velocity.x = velocity
	elif direction == "left":
		obj.global_position = global_position + Vector2(-40, 0)
		obj.velocity.x = -velocity
	elif direction == "down":
		obj.global_position = global_position + Vector2(0, 40)
		obj.velocity.y = velocity
	elif direction == "up":
		obj.global_position = global_position + Vector2(0, -40)
		obj.velocity.y = -velocity
		
	#Define the object rotation
	obj.rotation = Vector2(0, 1).angle_to(obj.velocity)
	
	#Add a new group
	obj.addNewGroup("damage")
	
	#Plays the Animations
	$StaticBody2D/AnimationPlayer.play("shooting")

#When a object collide with the brick
func areaEntered(body):
	if body.is_in_group("shoot"):
		$ProgressBar.value -= 15

#When the ProgressBar value is changed
func valueChanged(value):
	if value <= 0:
		queue_free()