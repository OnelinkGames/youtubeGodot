extends Node2D

#Vars from Character
const GRAVITY = 300.0
const WALK_SPEED = 300
const JUMP = -250
var hp = 1000
var direction = "right"
var velocity = Vector2()

#When the game begins
func _ready():
	#Connect the area Entered Signal
	$KinematicBody2D/Area2D.connect("area_entered", self, "areaEntered")

#All the Time (Character Movement and Jump and Animations)
func _physics_process(delta):
	if !$KinematicBody2D.is_on_floor():
		velocity.y += delta * GRAVITY

	if Input.is_action_pressed("ui_left"):
		velocity.x = -WALK_SPEED
		direction = "left"
		$KinematicBody2D/AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x =  WALK_SPEED
		direction = "right"
		$KinematicBody2D/AnimatedSprite.flip_h = false
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("jump"):
		if $KinematicBody2D.is_on_floor():
			velocity.y = JUMP
			$KinematicBody2D/AnimatedSprite.play("jumping")
			$KinematicBody2D/JumpSound.play()
	
	if velocity.x > 0 and velocity.y > 0 and $KinematicBody2D.is_on_floor():
		$KinematicBody2D/AnimatedSprite.play("walking")
	elif velocity.x < 0 and velocity.y > 0 and $KinematicBody2D.is_on_floor():
		$KinematicBody2D/AnimatedSprite.play("walking")
	elif velocity.x == 0 and velocity.y > 0 and $KinematicBody2D.is_on_floor():
		$KinematicBody2D/AnimatedSprite.play("idle")

    # We don't need to multiply velocity by delta because MoveAndSlide already takes delta time into account.

    # The second parameter of move_and_slide is the normal pointing up.
    # In the case of a 2d platformer, in Godot upward is negative y, which translates to -1 as a normal.
	$KinematicBody2D.move_and_slide(velocity, Vector2(0, -1))

#Returns the camera Position
func getCameraPosition():
	return $KinematicBody2D/Camera2D.get_camera_position()

#Damage the Character when he receives a shoot
func areaEntered(body):
	if body.is_in_group("damage"):
		$KinematicBody2D/ProgressBar.value -= 1