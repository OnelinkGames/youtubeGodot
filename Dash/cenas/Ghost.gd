extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar Tween para deletar ghost quando o tween completar
	$Tween.connect("tween_all_completed", self, "fim_tween")
	
	#Iniciar interpolação da visibilidade do ghost
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), .3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	pass # Replace with function body.

#Ao Acabar a função o ghost é deleteado
func fim_tween():
	queue_free()

#Função para alterar o flip h do ghost para ser igual ao do personagem
func alterar_lado(valor):
	$AnimatedSprite.flip_h = valor

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
