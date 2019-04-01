extends Node2D

#Criando uma variavel que somente aceita Inteiros
var numero : int

#Criando uma variavel que somente aceita Strings
var texto : String

#Criando referencia a variavel para "somente um Node2D"
onready var no2d : Node2D = $Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	numero = "52" as int #Definindo a variavel "int" como "String" e alterando para "int" com casting usando as
	texto = "Ola" #Definindo a variavel "String" como uma "String"
	
	#Somente chama o metodo do Node2D se o caminho $Node2D for realmente um Node2D
	($Node2D as Node2D).rotation = 70.0
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Chamando uma função, definindo o tipo dos argumento e o tipo do retorno.
func x(num : int, tex : String) -> String:
	return ""