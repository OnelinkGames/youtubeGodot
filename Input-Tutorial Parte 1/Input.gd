extends Node2D

#Referencias
onready var myself = self
onready var animacao = $AnimationPlayer
onready var area2d = $Sprite/Area2D

func _ready():
	#Realizar animação parado
	animacao.play("idle")
	
	#Realizar conexão input
	area2d.connect("input_event", myself, "MouseApertado")
	
	#Realizar conexão animacao
	animacao.connect("animation_finished", myself, "animacaoConcluida")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func MouseApertado(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed && event.button_index == 1:
			if animacao.get_current_animation() == "idle":
				animacao.play("attack")
			pass

func animacaoConcluida(anim):
	if anim == "attack":
		animacao.play("idle")
