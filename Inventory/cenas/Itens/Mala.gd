extends Sprite

# Variaveis do Objeto
var id: String
var nome: String
var descricao: String
var ataque: int
var defesa: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = "005"
	nome = "Bagagem Grande"
	descricao = "Bagagem grande para caber mais itens, aumenta a capacidade de 30 itens para 50 do seu inventario."
	ataque = 0
	defesa = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
