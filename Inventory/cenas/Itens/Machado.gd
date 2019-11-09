extends Sprite

# Variaveis do Objeto
var id: String
var nome: String
var descricao: String
var ataque: int
var defesa: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = "002"
	nome = "Machado de Guerra"
	descricao = "Um poderoso machado fabricado para a guerra de 100 anos."
	ataque = 50
	defesa = 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
