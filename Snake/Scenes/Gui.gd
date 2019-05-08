extends Control

#Variaveis
var my_score = 0
var timer = 300

#Sinais
signal morrer

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar Timer
	$Timer.connect("timeout", self, "contar_segundos")
	
	#Mostrar Timer
	$time.text = "Tempo Restante: " + str(timer) + " segundos"
	pass # Replace with function body.

#Adicionar Score
func add_score(score):
	my_score += score
	$score.text = "Score: " + str(my_score)

#Contar os segundos
func contar_segundos():
	timer -= 1
	$time.text = "Tempo Restante: " + str(timer) + " segundos"
	
	#Verificar se o tempo acabou
	if timer <= 0:
		emit_signal("morrer")
		$Timer.stop()
	else:
		$Timer.start()