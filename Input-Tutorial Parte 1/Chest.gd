extends StaticBody2D

#Referencias
onready var myself = self
onready var area2d = $Sprite/Area2D
onready var animacao = $AnimationPlayer

#Variaveis
var personagem
var bau = false

func _ready():
	#Iniciar Animação
	animacao.play("fechado")
	pass

#func _process(delta):
#	pass

func mensagem():
	$Label.set_visible(true)