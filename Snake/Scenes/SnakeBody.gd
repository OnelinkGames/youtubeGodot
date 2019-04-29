extends Node2D

#Variaveis
var posicao_atual = Vector2() #Variavel com a posição atual
var posicao_ant = Vector2() #Variavel com a posição anterior
var offset = 8 #Offset do Sprite.

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar Timer de Morrer
	$tempo_morrer.connect("timeout", self, "libertar")
	pass # Replace with function body.

#Função Mover
func mover(posicao_mover, ultimo):
	#Pegar Posição da Grid Atual
	posicao_atual = Grid.pixelsParaGrid(position, offset)
	
	#Salvar Posição Anterior
	posicao_ant = posicao_atual
	
	#Alterar Grid
	Grid.grid[posicao_mover.x - 1][posicao_mover.y - 1] = "SnakeBody" #Nova Posição
	
	if ultimo:
		Grid.grid[posicao_ant.x - 1][posicao_ant.y - 1] = "terreno" #Posição Anterior
	
	#Converter para posição
	var nova_posicao = Grid.gridParaPixels(posicao_mover, offset)
	
	#Atualizar Posição Atual
	posicao_atual = Grid.pixelsParaGrid(nova_posicao, offset)
	
	#Mover Corpo
	position = nova_posicao

#Função para Destruir o personagem
func destruir():
	$Sprite.visible = false
	$Particles2D.emitting = true
	$tempo_morrer.start()

#Função para tirar o objeto da tela.
func libertar():
	queue_free()

#Função Animar
func animar(animacao):
	$AnimationPlayer.play(animacao)