extends KinematicBody2D

#Constantes
const GRAVITY = 300
const UP = Vector2(0, -1)
const SPEED = 100
const JUMP = 180   

#Variaveis
var motion = Vector2()
var dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Gravidade
	if !is_on_floor():
		motion.y += GRAVITY * delta
	
	#Mover
	if Input.is_action_pressed("ui_right"):
		dir = 1
		$Sprite.flip_h = false
		motion.x = SPEED * dir
	elif Input.is_action_pressed("ui_left"):
		dir = -1
		$Sprite.flip_h = true
		motion.x = SPEED * dir
	else:
		dir = 0
		motion.x = SPEED * dir
	
	#Pular
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor(): #Condição no solo
			motion.y = -JUMP
	
	#move_and_slide_with_snap(motion, UP, Vector2(0, 32))
	move_and_slide(motion, UP)
	pass