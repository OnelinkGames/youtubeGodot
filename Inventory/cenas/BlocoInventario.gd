extends Node2D

# Variavel para usar teclado ou mouse
var usar_teclado: bool = false

# Variavel para guardar a posição do bloco
var posicao_bloco: Vector2 = Vector2()

# Variavel para guardar o item atual do bloco
var item_atual: int = 0
var item_anterior: int = 0

# Sinal para enviar posição para outro Node
signal enviar_valores

# Variavel para guardar referencia dos itens
var referencia_itens: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Conectar entrada do mouse
	#warning-ignore: return_value_discarded
	($Bloco/Area2D as Area2D).connect("mouse_entered", self, "_on_Area2D_mouse_entered")
	
	# Conectar saida do mouse
	#warning-ignore: return_value_discarded
	($Bloco/Area2D as Area2D).connect("mouse_exited", self, "_on_Area2D_mouse_exited")
	
	# Inicializar itens
	referencia_itens.append(null)
	for itens in ($Itens as Node2D).get_children():
		referencia_itens.append(itens)

# Função para alterar item atual
func alterar_item(valor: int) -> void:
	item_anterior = item_atual
	item_atual = valor
	
	if item_anterior != 0:
		referencia_itens[item_anterior].visible = false
	
	if item_atual != 0:
		referencia_itens[item_atual].visible = true

# Função para verificar se mouse esta na area do bloco
func _on_Area2D_mouse_entered() -> void:
	if usar_teclado == false:
		acender_bloco()

# Função para verificar se mouse saiu da area do bloco
func _on_Area2D_mouse_exited() -> void:
	if usar_teclado == false:
		apagar_bloco()

# Função para acender o bloco
func acender_bloco() -> void:
	modulate = Color(0.93, 0.69, 0.49, 1)
	if item_atual != 0:
		var temp = [referencia_itens[item_atual].nome, 
					referencia_itens[item_atual].descricao,
					str("ATK: ") + str(referencia_itens[item_atual].ataque), 
					str("DEF: ") + str(referencia_itens[item_atual].defesa)]
		emit_signal("enviar_valores", posicao_bloco, temp)
	else:
		emit_signal("enviar_valores", posicao_bloco, ["", "", "", ""])

# Função para apagar o bloco
func apagar_bloco() -> void:
	modulate = Color(0.98, 0.44, 0, 1)
	emit_signal("enviar_valores", posicao_bloco, ["", "", "", ""])