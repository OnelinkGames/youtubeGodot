extends KinematicBody2D

export (int) var run_speed = 200
export (int) var jump_speed = -600
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false

func _ready():
	$Music.play()
	pass

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('direita')
	var left = Input.is_action_pressed('esquerda')
	var jump = Input.is_action_just_pressed('pulo')

	if jump and is_on_floor():
		jumping = true
		velocity.y = jump_speed
		$Jump.play()
	elif right:
		velocity.x += run_speed
	elif left:
		velocity.x -= run_speed

func get_animation():
	var right = Input.is_action_pressed('direita')
	var left = Input.is_action_pressed('esquerda')
	var jump = Input.is_action_just_pressed('pulo')

	if right and is_on_floor():
		$AnimatedSprite.play("Walking")
		$AnimatedSprite.flip_h = false
	elif left and is_on_floor():
		$AnimatedSprite.play("Walking")
		$AnimatedSprite.flip_h = true
	elif not is_on_floor():
		$AnimatedSprite.play("Jumping")
	else:
		$AnimatedSprite.play("Idle")

func _physics_process(delta):
	get_input()
	get_animation()
	velocity.y += gravity * delta
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity, Vector2(0, -1))
