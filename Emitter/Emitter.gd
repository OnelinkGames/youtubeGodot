extends Node2D

#Vars from Object
export (PackedScene) var object #Object Scene.
var start_size #Start Size of the Viewport.
var end_size  #End Size of the Viewport.
var particle #The object for creation

#Vars for OneShot
var vel_counter = Vector2(0, 0) #Used in oneshot
var scale_counter = Vector2(0, 0) #Used in oneshot

#Change only these vars
export var object_name = "" #The object name
export var emitter = false #Set if the emitter is working or not.
export var alpha = false # If the object disapears or not
export var oneshot = false #if the particles will be shot all at the same time.
export var object_life_time = 0.0 #How many seconds the object will live.
export var emitter_time = 0.0 #How many time for wait for emitter to work.
export var emitter_counter = 0 #Quantity of Objects.
export var velocity = Vector2() #Initial Velocity of The Object.
export var velocity_random = Vector2() #Random Velocity of the Object.
export var object_scale = Vector2() #Initial Scale of The Object.
export var object_scale_random = Vector2() #Random scale of the Object.
export var dir = "" #direction of the rain (down - right - left).
export var area = Rect2()
export var size_diff = Vector2(0, 0) #Size Diference for Objects.
#Remember to change the rot and size_diff if you want to change the dir of the rain.

#Others
var sort  = 0 #Sort the position of the Emitter.
signal myobject #Signal for Sending Objects Infos.

# Called when the node enters the scene tree for the first time.
func _ready():
	#Set Time OneShot
	if emitter == false:
		$Timer.set_one_shot(true)
	#Set the time space of emitter
	$Timer.set_wait_time(emitter_time)
	#Start or not the Emitter
	if emitter == true:
		$Timer.start()
	#Get the size of the viewport
	start_size = area.position
	end_size = area.size
	$Timer.connect("timeout", self, "timeIsOver") #Connect the timer
	randomize()
	pass # Replace with function body.

#Function for particle generation
func particleCreation():
	#Set the oneshot
	vel_counter = Vector2(0, 0)
	scale_counter = Vector2(0, 0)
	
	#Check how many Objects will fall
	for i in range(emitter_counter):
		#Instance the Drop
		particle = object.instance() #Create the instance of the drop
		
		#Check if the rain is falling on right or left
		if dir != "down":
			if sort == 0: # if the sort is 0
				#Set the drop position and the random factor on x
				particle.position = Vector2(rand_range(start_size.x, end_size.x), start_size.y)
				sort = 1
			else:
				if dir == "right":
					#Set the drop position and the random factor on y
					particle.position = Vector2(start_size.x, rand_range(start_size.y, size_diff.y))
				else:
					#Set the drop position and the random factor on y
					particle.position = Vector2(end_size.x, rand_range(start_size.y, size_diff.y))
				sort = 0
		else:
			#Set the drop position and the random factor
				particle.position = Vector2(rand_range(start_size.x, end_size.x), start_size.y)
		
		#Check the OneShot var
		if oneshot == false:
			#Set the drop velocity and the random factor
			particle.velocity = velocity + Vector2(rand_range(0, velocity_random.x), rand_range(0, velocity_random.y))
			#Set the drop scale and the random factor.
			particle.scale = object_scale + Vector2(rand_range(0, object_scale_random.x), rand_range(0, object_scale_random.y))
		else:
			#Create Vars for random
			vel_counter += velocity_random
			scale_counter += object_scale_random
			#Set the drop velocity and the random factor
			particle.velocity = velocity + Vector2(vel_counter.x, vel_counter.y)
			#Set the drop scale and the random factor.
			particle.scale = object_scale + Vector2(scale_counter.x, scale_counter.y)
		
		#Set the lifetime of the object
		particle.setTimeLife(object_life_time)
		
		#Set the particle name and add to group
		particle.new_name = object_name
		particle.addNewGroup(object_name)
		
		#Particles alpha
		if alpha == true:
			particle.alpha = true
		
		#Emit Signal
		emit_signal("myobject", particle)

#Fire the Particle
func fireParticles():
	$Timer.start()
	
#When the time is Over
func timeIsOver():
	particleCreation()
	if emitter == true:
		$Timer.start() #Start the time again