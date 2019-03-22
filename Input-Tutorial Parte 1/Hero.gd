extends Node2D

#Referencias
onready var heroi = self
onready var animacao = $AnimatedSprite
onready var raycast = $AnimatedSprite/RayCast2D

#Variaveis
var movimento = Vector2()
var velocidade = 3000

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		movimento.y = 0
		movimento.x = velocidade * delta
	elif Input.is_action_pressed("ui_left"):
		movimento.y = 0
		movimento.x = -(velocidade * delta)
	elif Input.is_action_pressed("ui_up"):
		movimento.x = 0
		movimento.y = -(velocidade * delta)
	elif Input.is_action_pressed("ui_down"):
		movimento.x = 0
		movimento.y = velocidade * delta
	else:
		movimento.x = 0
		movimento.y = 0
	
	if Input.is_action_just_pressed("ui_right"):
		animacao.play("WalkingSides")
		animacao.set_flip_h(false)
	elif Input.is_action_just_pressed("ui_left"):
		animacao.play("WalkingSides")
		animacao.set_flip_h(true)
	elif Input.is_action_just_pressed("ui_up"):
		animacao.play("WalkingUp")
		animacao.set_flip_h(false)
	elif Input.is_action_just_pressed("ui_down"):
		animacao.play("WalkingDown")
		animacao.set_flip_h(false)
	
	if Input.is_action_just_released("ui_right") || Input.is_action_just_released("ui_left") || Input.is_action_just_released("ui_up") || Input.is_action_just_released("ui_down"):
		animacao.set_frame(4)
		animacao.stop()
	
	heroi.move_and_slide(movimento)
	
	var collider = raycast.get_collider()
	if collider != null:
		print(collider.get_name())
		print(collider.get_path())
	pass

func animacaoAtual():
	return animacao.get_animation()
