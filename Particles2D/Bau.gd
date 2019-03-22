extends Node2D

onready var particulas = $Particles2D

var enviar = Vector3()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		enviar = Vector3(50, -50, 0)
		vento(enviar)
		pass
	if Input.is_action_just_pressed("ui_left"):
		enviar = Vector3(-50, -50, 0)
		vento(enviar)
		pass
	if Input.is_action_just_pressed("ui_up"):
		enviar = Vector3(0, -70, 0)
		vento(enviar)
		pass
	if Input.is_action_just_pressed("ui_down"):
		enviar = Vector3(0, -10, 0)
		vento(enviar)
		pass
	pass

func vento(valor):
	particulas.process_material.set_gravity(valor)
	pass
