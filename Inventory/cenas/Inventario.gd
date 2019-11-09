extends Control

#Cena do Bloco do Inventario
var bloco_inventario: PackedScene = load("res://cenas/BlocoInventario.tscn")

# Tamanho do inventario (Quantidade de itens x,y)
export var inventario_tamanho: Vector2 = Vector2()

# Tamanho x,y de cada bloco do invetario.
export var tamanho_bloco: Vector2 = Vector2()

# Variavel para centralizar o inventario.
export var centralizar: bool = false

# Variavel para utilizar o teclado
export var usar_teclado: bool = false

# Variavel para controle de posição atual e anterior
var posicao_atual: Vector2 = Vector2(0, 0)
var posicao_anterior: Vector2 = Vector2(0, 0)

# Referencia para blocos
var referencia_blocos: Array

# Cria uma array 2d vazia
func create_2d_array(width: int, height: int, value: Object) -> Array:
	var array: Array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(value)
	return array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Criar referencia de blocos
	#warning-ignore: narrowing_conversion
	#warning-ignore: narrowing_conversion
	referencia_blocos = create_2d_array(inventario_tamanho.x, inventario_tamanho.y, null)
	
	# Contruir fundo do inventario.
	var tam_inventario_x: float = (inventario_tamanho.x * tamanho_bloco.x) + (inventario_tamanho.x * 2) + tamanho_bloco.x
	var tam_inventario_y: float = (inventario_tamanho.y * tamanho_bloco.y) + (inventario_tamanho.y * 2) + tamanho_bloco.y
	if centralizar:
		var pos_inventario_x: float = ($FundoInventario as NinePatchRect).rect_position.x - (tam_inventario_x / 2)
		var pos_inventario_y: float = ($FundoInventario as NinePatchRect).rect_position.y - (tam_inventario_y / 2)
		($FundoInventario as NinePatchRect).rect_position = Vector2(pos_inventario_x, pos_inventario_y)
	($FundoInventario as NinePatchRect).rect_size  = Vector2(tam_inventario_x, tam_inventario_y)
	
	# Contruir blocos do inventario
	for coluna in range(inventario_tamanho.x):
		for linha in range(inventario_tamanho.y):
			# Instanciar bloco
			var bloco_final: Object = bloco_inventario.instance()
			
			# Ajuste de distancia entre blocos
			var mover: Vector2 = Vector2(coluna*2, linha*2)
			
			# Calcular a posição final de cada bloco
			var bloco_x: float = ($FundoInventario as NinePatchRect).rect_position.x + (tamanho_bloco.x / 2) + (coluna * tamanho_bloco.x) + mover.x
			var bloco_y: float = ($FundoInventario as NinePatchRect).rect_position.y + (tamanho_bloco.y / 2) + (linha * tamanho_bloco.y) + mover.y
			
			# Colocar bloco na cena
			($Blocos as Node2D).add_child(bloco_final)
			
			# Mover cada bloco para sua posição correta.
			bloco_final.position = Vector2(bloco_x, bloco_y)
			
			# Variaveis do bloco
			bloco_final.usar_teclado = usar_teclado
			bloco_final.posicao_bloco = Vector2(coluna, linha)
			
			# Conexões do bloco
			#warning-ignore: return_value_discarded
			bloco_final.connect("enviar_valores", self, "atualizar_valores")
			
			#Adicionar bloco a referencias
			referencia_blocos[coluna][linha] = bloco_final
	
	# Iniciar posição inicial de bloco caso seja teclado
	if usar_teclado:
		referencia_blocos[posicao_atual.x][posicao_atual.y].acender_bloco()
	
	# Desligar o inventario no começo do level.
	set_process(false)
	set_process_input(false)
	visible = false

# Função para iniciar o inventario
func iniciar_inventario():
	# get_tree().paused = true
	posicao_atual = Vector2(0, 0)
	posicao_anterior = Vector2(0, 0)
	if usar_teclado:
		referencia_blocos[posicao_atual.x][posicao_atual.y].acender_bloco()
	set_process(true)
	set_process_input(true)
	visible = true

# Função para desligar o inventario
func desligar_inventario():
	referencia_blocos[posicao_atual.x][posicao_atual.y].apagar_bloco()
	visible = false
	set_process_input(false)
	set_process(false)
	# get_tree().paused = false
	

# Função para recuperar valor de bloco e mostrar
func atualizar_valores(valor: Vector2, lista_objeto: Array) -> void:
	if usar_teclado == false:
		posicao_atual = valor
	($Descritivo/NomeTexto as Label).text = str(lista_objeto[0])
	($Descritivo/DescricaoTexto as Label).text = str(lista_objeto[1])
	($Descritivo/AtaqueTexto as Label).text = str(lista_objeto[2])
	($Descritivo/DefesaTexto as Label).text = str(lista_objeto[3])

# Função para movimentar inventario por teclado
func movimentar_teclado(pos_anterior: Vector2, pos_proximo: Vector2) -> void:
	# Alterar variaveis
	posicao_anterior = pos_anterior
	posicao_atual = pos_proximo
	
	# Alterar Objetos
	referencia_blocos[posicao_anterior.x][posicao_anterior.y].apagar_bloco()
	referencia_blocos[posicao_atual.x][posicao_atual.y].acender_bloco()

# Função para buscar um bloco vazio
func adicionar_item(item: int) -> void:
	var referencia_temporaria: Object = null
	for coluna in range(inventario_tamanho.x):
		for linha in range(inventario_tamanho.y):
			if referencia_blocos[linha][coluna].item_atual == 0 and referencia_temporaria == null:
				referencia_temporaria = referencia_blocos[linha][coluna]
				break
	
	if referencia_temporaria != null:
		referencia_temporaria.alterar_item(item)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#warning-ignore: unused_argument
func _process(delta) -> void:
	if usar_teclado:
		if Input.is_action_just_pressed("ui_right"):
			if posicao_atual.x < (inventario_tamanho.x - 1):
				movimentar_teclado(posicao_atual, Vector2(posicao_atual.x + 1, posicao_atual.y))
		if Input.is_action_just_pressed("ui_left"):
			if posicao_atual.x > 0:
				movimentar_teclado(posicao_atual, Vector2(posicao_atual.x - 1, posicao_atual.y))
		if Input.is_action_just_pressed("ui_up"):
			if posicao_atual.y > 0:
				movimentar_teclado(posicao_atual, Vector2(posicao_atual.x, posicao_atual.y - 1))
		if Input.is_action_just_pressed("ui_down"):
			if posicao_atual.y < (inventario_tamanho.y - 1):
				movimentar_teclado(posicao_atual, Vector2(posicao_atual.x, posicao_atual.y + 1))

func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_0 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(0)
		if event.pressed and event.scancode == KEY_1 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(1)
		if event.pressed and event.scancode == KEY_2 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(2)
		if event.pressed and event.scancode == KEY_3 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(3)
		if event.pressed and event.scancode == KEY_4 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(4)
		if event.pressed and event.scancode == KEY_5 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(5)
		if event.pressed and event.scancode == KEY_6 and event.echo == false:
			referencia_blocos[posicao_atual.x][posicao_atual.y].alterar_item(6)
		
		if event.pressed and event.scancode == KEY_ENTER and event.echo == false:
			var item_temporario: int = randi() % 6 + 1
			adicionar_item(item_temporario)
		
		if event.pressed and event.scancode == KEY_9 and event.echo == false:
			desligar_inventario()