extends Node2D

#Vars
var size #Size of the Screen

#When the game begins
func _ready():
	size = get_viewport().get_visible_rect().size #Get the size of the screen
	#Connect the Drop From Rain to Creation
	$SandStorm.connect("myobject", self, "rain")
	#Connect the Particles Signal
	$Personagem/Shoot.connect("myobject", self, "meuTiro")
	pass

#Occurs all the time
func _process(delta):
	#BG Position
	$BG.position = $Personagem.getCameraPosition()
	
	#Fire
	if Input.is_action_just_pressed("fire"):
		$Personagem/Shoot.fireParticles()
		$Personagem/Shoot/ShootSound.play()

#For the Shoot Creation
func meuTiro(obj):
	#Add the Child
	$Particles.add_child(obj)
	
	#Calculate the Object position
	if $Personagem.direction == "right":
		obj.global_position = $Personagem/KinematicBody2D.global_position + Vector2(30, 0)
		obj.velocity.x = 10
	else:
		obj.global_position = $Personagem/KinematicBody2D.global_position + Vector2(-30, 0)
		obj.velocity.x = -10
		
	#Define the object rotation
	obj.rotation = Vector2(0, 1).angle_to(obj.velocity)
	
	#Color of the Drop
	var color = Color("#8c8c8c")
	obj.set_modulate(color)
	
	#Add a new group
	obj.addNewGroup("shoot")

#Create the Drop
func rain(obj):
	#Add the Object do the scene
	$Particles.add_child(obj)
	
	#Calculate the Object position
	var pos = Vector2($Personagem.getCameraPosition().x - (size.x/2), $Personagem.getCameraPosition().y - (size.y/2))
	pos = pos + obj.position
	obj.global_position = pos
	
	#Define the object rotation
	obj.rotation = Vector2(0, 1).angle_to(obj.velocity)
	
	#Color of the Drop
	var color = Color(rand_range(0.7, 1.0), 0.6, 0.2)
	obj.set_modulate(color)
	
	#Add a new group
	obj.addNewGroup("notCollide")