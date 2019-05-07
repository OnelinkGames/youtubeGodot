extends Node2D

#Fruta
onready var fruta = preload("res://Scenes/Fruta.tscn")

#Iniciar o Main
func _ready():
	#Conectar tempo
	$Timer.connect("timeout", self, "createFruit")
	
	#Conectar a gui
	$Snake2D.connect("score", $CanvasLayer/Gui, "add_score")
	
	#Randomizar
	randomize()
	
	#Blocos para Grid
	var tile = $TileMap2.get_used_cells() #Recuperar blocos
	
	#Transformar na Grid
	for i in range(tile.size()):
		Grid.grid[tile[i].x][tile[i].y] = "brick"

#Criar as frutas
func createFruit():
	var largura = int(round(rand_range(1, Grid.largura - 1)))
	var altura = int(round(rand_range(1, Grid.altura - 1)))
	while(Grid.checarItens(Vector2(largura - 1, altura - 1))):
		largura = int(round(rand_range(1, Grid.largura - 1)))
		altura = int(round(rand_range(1, Grid.altura - 1)))
	Grid.grid[largura - 1][altura - 1] = "fruta"
	var minhaFruta = fruta.instance()
	$Frutas.add_child(minhaFruta)
	minhaFruta.position = Grid.gridParaPixels(Vector2(largura, altura), 8)
	$Timer.start()