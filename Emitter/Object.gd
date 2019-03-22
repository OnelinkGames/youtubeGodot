extends Node2D

#Vars from drop
var velocity = Vector2() #Velocity of the drop
var state = true #Drop is active or not.
var size #Get the screen size
var life_time = 0 #Life Time of the Object
var rotate = false #Rotate or not the object
var rotate_speed = 0 #Speed of rotation
var new_name = ""
var fps = 60
var alpha = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#Start the Time
	$Timer.start()
	#Plays the Animation
	$Area2D/AnimatedSprite.play("drop")
	#Connect the area entered from drop
	$Area2D.connect("body_entered", self, "bodyEntered")
	if !$Area2D.is_in_group("notCollide"):
		#Connect the area entered from drop
		$Area2D.connect("area_entered", self, "areaEntered")
	#Connect the Animation End
	$Area2D/AnimatedSprite.connect("animation_finished", self, "animationFinished")
	#Connect the Time
	$Timer.connect("timeout", self, "timeIsOver")
	size = get_viewport().get_visible_rect().size #Screen size
	pass # Replace with function body.

#Check all the time
func _process(delta):
	#Make the node rotate
	if rotate == true && state == true:
		rotation += (rotate_speed * fps) * delta
	
	#If the state is true the drop will fall.
	if state == true:
		global_position += (velocity * fps) * delta
	
	#Alpha the Particles
	if alpha == true:
		var alpha = (1 * $Timer.time_left) / $Timer.wait_time
		modulate.a = alpha

#Disable collision
func disableCollision():
	$Area2D/CollisionShape2D.disabled = true

#When the Animation Ends
func animationFinished():
	if $Area2D/AnimatedSprite.animation == "break":
		queue_free()

#When the object collides.
func bodyEntered(body):
	#If the body is not on group of notCollide the object will be destroyed
	if !body.is_in_group("notCollide"):
		if !body.is_in_group(new_name):
			state = false #Don´t move the object anymore
			$Area2D/AnimatedSprite.play("break") #Plays the Animation
			disableCollision()

#When the object collides.
func areaEntered(body):
	#If the body is not on group of notCollide the object will be destroyed
	if !body.is_in_group("notCollide") && $Area2D/AnimatedSprite.animation == "drop":
		if !body.is_in_group(new_name):
			state = false #Don´t move the object anymore
			$Area2D/AnimatedSprite.play("break") #Plays the Animation
			disableCollision()

#When the time is over
func timeIsOver():
	queue_free()

#Set the scale of the sprite.
func spriteSetScale(value):
	$Area2D/Sprite.set_scale(value)

#Recover the scale of the sprite.
func spriteGetScale():
	return $Area2D/Sprite.get_scale()

#Set The life time of the object
func setTimeLife(value):
	$Timer.set_wait_time(value)

#Add a new Group
func addNewGroup(value):
	$Area2D.add_to_group(value)

#Remove from Group
func removeGroup(value):
	$Area2D.remove_from_group(value)