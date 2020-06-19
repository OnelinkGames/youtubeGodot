extends Node2D

#Variaveis da Grid
export var largura = 0
export var altura = 0
export var tamanhoBloco = 0

#Variaveis Internas
var grid #Minha Grid

# Called when the node enters the scene tree for the first time.
func _ready():
	#Criar Array e Mapear
	grid = criarArray()
	mapearGrid(grid)
	pass # Replace with function body.

#Função para Criar Array
func criarArray():
	var array = []
	for i in largura:
		array.append([])
		for j in altura:
			array[i].append(null)
	return array

#Função para pegar a grid de uma posição
func pixelsParaGrid(posicao, offset):
	var i = round(posicao.x  / tamanhoBloco)
	var j = round(posicao.y / tamanhoBloco)
	return Vector2(i, j)

#Função para transformar Grid para Pixels
func gridParaPixels(posicao, offset):
	var x = (posicao.x * tamanhoBloco) - offset
	var y = (posicao.y * tamanhoBloco) - offset
	return Vector2(x, y)

#Mapear Grid
func mapearGrid(myGrid):
	for i in largura:
		for j in altura:
			myGrid[i][j] = "terreno"
	return myGrid

#função Checar Itens
func checarItens(posicao):
	if grid[posicao.x][posicao.y] != "terreno":
		return true
	else:
		return false

#Função para Mostrar obstaculos na tela.
func pintar():
	for i in largura:
		for j in altura:
			var quadrado = Rect2(gridParaPixels(Vector2(i, j), 0), Vector2(16, 16))
			
			if grid[i][j] == "terreno":
				draw_rect(quadrado,  Color(0.33, 0.42, 0.18, .5), true)
			else:
				draw_rect(quadrado,  Color(0.86, 0.08, 0.24, .5), true)

#Desenhar na tela
func _draw():
	#pintar()
	pass
