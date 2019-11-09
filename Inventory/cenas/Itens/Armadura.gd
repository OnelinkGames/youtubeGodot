extends Sprite

# Variaveis do Objeto
var id: String
var nome: String
var descricao: String
var ataque: int
var defesa: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = "006"
	nome = "Armadura Escura"
	descricao = "Uma armadura negra forjada dos metais de Sauron."
	ataque = 5
	defesa = 10000

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
