extends Node2D

#TODO
#Erros Grid -1

#Variaveis Export
export var spawnar = Vector2()
export var direcao_spawnar = Vector2()

#Sinais
signal score

#Referências
var corpo = preload("res://Scenes/SnakeBody.tscn")
var score = 0

#Variaveis
var direction = Vector2() #Direção que a Snake está se movendo
var offset = 8 #Offset para ajustar posição da Snake
var referencias = [] #Referencias dos pedaços da Snake
var posicao_ant = Vector2() #Variavel para guardar a posição anterior
var posicao_atual = Vector2() #Variavel para guardar a posição atual
var movendo = false #Variavel para verificar se esta parado ou movendo

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar Timer Mover
	$move_timer.connect("timeout", self, "mover")
	
	#Conectar Timer Tempo Mover
	$tempo_morrer.connect("timeout", self, "libertar")
	
	#Conectar Colisor Area
	$colisor.connect("area_entered", self, "colidirArea")
	
	#Conectar Colisor Body
	$colisor.connect("body_entered", self, "colidirBody")
	
	#Definir posição inicial da Snake
	var posicao = Grid.gridParaPixels(spawnar, offset)
	position = posicao
	
	#Recuperar a posição atual
	posicao_atual = Grid.pixelsParaGrid(position, offset)
	posicao_ant = Vector2(posicao_atual.x - direcao_spawnar.x, posicao_atual.y - direcao_spawnar.y)
	
	#Adicionar referência da Cabeça da Snake
	referencias.append(self)
	
	#Direção da Snake
	direction = direcao_spawnar * -1
	
	#Adicionar dois pedaços do corpo
	var pos = posicao_atual
	for i in range(2):
		#Instanciar
		var objeto_corpo = corpo.instance()
		
		#Adicionar Objeto
		get_owner().call_deferred("add_child", objeto_corpo)
		
		#Arrumar Posição
		var posicao_local = pos
		posicao_local += direcao_spawnar
		
		#Atualizar variavel do objeto
		objeto_corpo.posicao_atual = posicao_local
		objeto_corpo.posicao_ant += posicao_local + direcao_spawnar
		
		#Atualizar posição do Objeto
		var posicao_pixel = Grid.gridParaPixels(posicao_local, offset)
		objeto_corpo.position = posicao_pixel
		
		#Adicionar referência
		referencias.append(objeto_corpo)
		
		#Modificar posição
		pos = posicao_local
	
	#Iniciar Tempo
	$move_timer.start()
	pass # Replace with function body.

#Função para atualizar posição da Snake
func mover():
	#Pegar Posição da Grid Atual
	posicao_atual = Grid.pixelsParaGrid(position, offset)
	
	#Salvar Posição Anterior
	posicao_ant = posicao_atual
	
	#Verificar direção e alterar Grid
	if direction.x == 1:
		$Sprite.rotation_degrees = 0
		posicao_atual.x += 1
	elif direction.x == -1:
		$Sprite.rotation_degrees = 180
		posicao_atual.x -= 1
	elif direction.y == 1:
		$Sprite.rotation_degrees = 90
		posicao_atual.y += 1
	elif direction.y == -1:
		$Sprite.rotation_degrees = 270
		posicao_atual.y -= 1
	
	#Alterar Grid
	Grid.grid[posicao_atual.x - 1][posicao_atual.y - 1] = "SnakeHead" #Nova Posição
	
	#Converter para posição
	var nova_posicao = Grid.gridParaPixels(posicao_atual, offset)
	
	#Mover Snake
	position = nova_posicao
	
	#Atualizar referências
	atualizar_referencias(posicao_ant)
	
	#Reiniciar Tempo
	$move_timer.start()
	
	#Grid
	#Grid.update()
	pass

#Função para atualizar as referências
func atualizar_referencias(pos):
	var minha_posicao = pos
	for i in range(referencias.size()):
		if i > 0:
			if i != (referencias.size() - 1):
				referencias[i].mover(minha_posicao, false)
			else:
				referencias[i].mover(minha_posicao, true)
			minha_posicao = referencias[i].posicao_ant
			animar(i)

#Função para Colidir contra objetos
func colidirBody(body):
	destruir()

#Função para comer as frutas e Colidir no Proprio Corpo
func colidirArea(area):
	#Comer Maça
	if area.is_in_group("fruta"):
		
		#Excluir Maça
		area.get_owner().queue_free()
		
		#Adicionar pontuação
		emit_signal("score", 10)
		
		#Som
		$eat.play()
		
		#Instanciar o corpo
		var objeto_corpo = corpo.instance()
		
		#Posição do corpo
		objeto_corpo.position = Vector2(-50, -50)
		
		#Adicionar corpo na cena
		get_owner().call_deferred("add_child", objeto_corpo)
		
		#Adicionar as referencias
		referencias.append(objeto_corpo)
	
	#Colidir Corpo
	if area.is_in_group("corpo"):
		destruir()

#Função para Destruir o personagem
func destruir():
	set_process(false)
	$move_timer.stop()
	$Sprite.visible = false
	$Particles2D.emitting = true
	$tempo_morrer.start()
	$die.play()
	for i in range(referencias.size()):
		if i > 0:
			referencias[i].destruir()

#Função para tirar o objeto da tela.
func libertar():
	queue_free()
	get_tree().change_scene("res://Scenes/Main.tscn")

#Função de Animar
func animar(i):
	if i != (referencias.size() - 1):
		#Variaveis
		var anterior = Grid.gridParaPixels(referencias[i-1].posicao_atual, offset)
		var meuObjeto = Grid.gridParaPixels(referencias[i].posicao_atual, offset)
		var proximo = Grid.gridParaPixels(referencias[i].posicao_ant, offset)
		var r = i
		
		#Caso 1
		if (meuObjeto.y > anterior.y || meuObjeto.y < anterior.y) && (meuObjeto.y > proximo.y || meuObjeto.y < proximo.y):
			if meuObjeto.x == anterior.x && meuObjeto.x == proximo.x:
				referencias[r].animar("corpo")
				referencias[r].rotation_degrees = 90
		
		#Caso 2
		if (meuObjeto.x > anterior.x || meuObjeto.x < anterior.x) && (meuObjeto.x > proximo.x || meuObjeto.x < proximo.x):
			if meuObjeto.y == anterior.y && meuObjeto.y == proximo.y:
				referencias[r].animar("corpo")
				referencias[r].rotation_degrees = 0
		
		
		#Caso 3
		if (meuObjeto.x < anterior.x && meuObjeto.y == anterior.y) || (meuObjeto.x < proximo.x && meuObjeto.y == proximo.y):
			if (meuObjeto.y < anterior.y && meuObjeto.x == anterior.x) || (meuObjeto.y < proximo.y && meuObjeto.x == proximo.x):
				referencias[r].animar("diagonal")
				referencias[r].rotation_degrees = 270
		
		#Caso 4
		if (meuObjeto.x > anterior.x && meuObjeto.y == anterior.y) || (meuObjeto.x > proximo.x && meuObjeto.y == proximo.y):
			if (meuObjeto.y < anterior.y && meuObjeto.x == anterior.x) || (meuObjeto.y < proximo.y && meuObjeto.x == proximo.x):
				referencias[r].animar("diagonal")
				referencias[r].rotation_degrees = 0
		
		#Caso 5
		if (meuObjeto.x < anterior.x && meuObjeto.y == anterior.y) || (meuObjeto.x < proximo.x && meuObjeto.y == proximo.y):
			if (meuObjeto.y > anterior.y && meuObjeto.x == anterior.x) || (meuObjeto.y > proximo.y && meuObjeto.x == proximo.x):
				referencias[r].animar("diagonal")
				referencias[r].rotation_degrees = 180
		
		#Caso 6
		if (meuObjeto.x > anterior.x && meuObjeto.y == anterior.y) || (meuObjeto.x > proximo.x && meuObjeto.y == proximo.y):
			if (meuObjeto.y > anterior.y && meuObjeto.x == anterior.x) || (meuObjeto.y > proximo.y && meuObjeto.x == proximo.x):
				referencias[r].animar("diagonal")
				referencias[r].rotation_degrees = 90
		
	else:
		#Variaveis
		var anterior = Grid.gridParaPixels(referencias[i-1].posicao_atual, offset)
		var meuObjeto = Grid.gridParaPixels(referencias[i].posicao_atual, offset)
		var r = i
		
		#Caso 1
		if (meuObjeto.y > anterior.y):
			if meuObjeto.x == anterior.x:
				referencias[r].animar("cauda")
				referencias[r].rotation_degrees = 270
		
		#Caso 2
		if (meuObjeto.y < anterior.y):
			if meuObjeto.x == anterior.x:
				referencias[r].animar("cauda")
				referencias[r].rotation_degrees = 90
		
		#Caso 3
		if (meuObjeto.x > anterior.x):
			if meuObjeto.y == anterior.y:
				referencias[r].animar("cauda")
				referencias[r].rotation_degrees = 180
				
		#Caso 4
		if (meuObjeto.x < anterior.x):
			if meuObjeto.y == anterior.y:
				referencias[r].animar("cauda")
				referencias[r].rotation_degrees = 0

#Ocorre o tempo todo no jogo
func _process(delta):
	#Escolher direção da Snake e alterar rotação e mover snake
	if Input.is_action_pressed("ui_right") and $Sprite.rotation_degrees != 180:
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("ui_left") and $Sprite.rotation_degrees != 0:
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("ui_down") and $Sprite.rotation_degrees != 270:
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("ui_up") and $Sprite.rotation_degrees != 90:
		direction = Vector2(0, -1)
	pass
