extends Control

var currentScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#Função para diminuir o hp
func dano(dano):
	$ProgressBar.value -= dano

#Função para aumentar o score
func score(score):
	currentScore += score
	$score.text = "Score: " + str(currentScore)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
