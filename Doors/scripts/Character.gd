extends KinematicBody2D

# variables
var move_vector : Vector2 = Vector2.ZERO
var direction : Vector2 = Vector2.ZERO
var animation: AnimationPlayer
var sprite : Sprite

# export variables
export var texture : Texture
export var up : String
export var right : String
export var down : String
export var left : String
export var action: String
export var speed : int

# Called when the node enters the scene tree for the first time.
func _ready():
	# start the nodes
	sprite = $Sprite
	animation = $AnimationPlayer
	
	# insert the texture.
	sprite.texture = texture
	pass

func _process(_delta):
	# movement and animation
	movement_and_animation()

# function to move and animate the character
func movement_and_animation():
	# clear input
	move_vector = Vector2.ZERO
	
	# input check
	if (Input.is_action_pressed(up)):
		# define velocity
		move_vector.y -= 1
		move_vector.x = 0
		
		# define direction
		direction.y = -1
		direction.x = 0
		
		# define animation
		animation.play("up")
	
	if (Input.is_action_pressed(down)):
		# define velocity
		move_vector.y += 1
		move_vector.x = 0
		
		# define direction
		direction.y = 1
		direction.x = 0
		
		# define animation
		animation.play("down")
		
	if (Input.is_action_pressed(right)):
		# define velocity
		move_vector.x += 1
		move_vector.y = 0
		
		# define direction
		direction.x = 1
		direction.y = 0
		
		# define animation
		animation.play("right")
		
	if (Input.is_action_pressed(left)):
		# define velocity
		move_vector.x -= 1
		move_vector.y = 0
		
		#define direction
		direction.x = -1
		direction.y = 0
		
		# define animation
		animation.play("left")
	
	# stop
	if (!Input.is_action_pressed(up) &&
	!Input.is_action_pressed(down) &&
	!Input.is_action_pressed(right) &&
	!Input.is_action_pressed(left)):
		if (animation.current_animation != ""):
			animation.seek(0, true)
			animation.stop()
	
	# move
	move_vector = move_vector.normalized() * speed
	move_vector = move_and_slide(move_vector)
