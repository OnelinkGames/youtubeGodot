extends Sprite

# Variaveis do Objeto
var id: String
var nome: String
var descricao: String
var ataque: int
var defesa: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	id = "003"
	nome = "Carne Viking"
	descricao = "Um delicioso pedaço de coxa das vacas milenares, prato muito apreciado durante a guerra de 100 anos e que enchia a energia dos combatentes."
	ataque = 0
	defesa = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
