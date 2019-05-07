extends Control

#Variaveis
var my_score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#Adicionar Score
func add_score(score):
	my_score += score
	$HBoxContainer/Label.text = "Score: " + str(my_score)
