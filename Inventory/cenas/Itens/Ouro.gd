extends Sprite

# Variaveis do Objeto
var id: String
var nome: String
var descricao: String
var ataque: int
var defesa: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = "004"
	nome = "Saco de Ouro"
	descricao = "Pacote com 50 moedas de ouro, é possivel comprar muitas coisas com isto."
	ataque = 0
	defesa = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
