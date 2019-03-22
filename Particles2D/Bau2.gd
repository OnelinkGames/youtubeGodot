extends Node2D

onready var particulas = $Particles2D
onready var animacao = $Sprite/AnimationPlayer
onready var tempo = $Timer

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	
#pass


func _on_Area2D_input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(1):
		animacao.play("abrir")
	pass # replace with function body


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "abrir":
		tempo.start()
		particulas.restart()
	pass # replace with function body


func _on_Timer_timeout():
	animacao.play("fechado")
	pass # replace with function body
