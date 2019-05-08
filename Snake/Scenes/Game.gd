extends Node2D

#Fruta
onready var fruta = preload("res://Scenes/Fruta.tscn")

#Velocidade do som
var velocidade_som = 0.0
var velocidade_final = 0.0

#Iniciar o Main
func _ready():
	#Conectar tempo
	$Timer.connect("timeout", self, "createFruit")
	
	#Conectar a gui
	$Snake2D.connect("score", $CanvasLayer/Gui, "add_score")
	
	#Conectar Tween
	$Tween.connect("tween_completed", self, "terminou_tween")
	
	#Conectar a Gui a Snake
	$CanvasLayer/Gui.connect("morrer", $Snake2D, "destruir")
	
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
	
	#Alterar velocidade do som
	velocidade_som += 0.01
	
	#Reiniciar Criação da Fruta
	$Timer.start()

#Alterar velocidade e som
func alterar():
	#Variavel para a transition
	var transition = Tween.TRANS_LINEAR
	
	#Verificar a variavel velocidade_som para alterar a velocidade do som e da Snake
	if velocidade_som < 0.5:
		if velocidade_final < 0.5:
			$Tween.interpolate_property($GameSound, "pitch_scale", 0.01, 0.5, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.3
			velocidade_final = 0.5
	elif velocidade_som < 1.0 && velocidade_som >= 0.5:
		if velocidade_final < 1 && velocidade_final >= 0.5:
			$Tween.interpolate_property($GameSound, "pitch_scale", 0.5, 1.0, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.25
			velocidade_final = 1.0
	elif velocidade_som < 1.5 && velocidade_som >= 1.0:
		if velocidade_final < 1.5 && velocidade_final >= 1.0:
			$Tween.interpolate_property($GameSound, "pitch_scale", 1.0, 1.5, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.20
			velocidade_final = 1.5
	elif velocidade_som < 2.0 && velocidade_som >= 1.5:
		if velocidade_final < 2.0 && velocidade_final >= 1.5:
			$Tween.interpolate_property($GameSound, "pitch_scale", 1.5, 2.0, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.15
			velocidade_final = 2.0
	elif velocidade_som < 2.5 && velocidade_som >= 2.0:
		if velocidade_final < 2.5 && velocidade_final >= 2.0:
			$Tween.interpolate_property($GameSound, "pitch_scale", 2.0, 2.5, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.10
			velocidade_final = 2.5
	elif velocidade_som < 3.0 && velocidade_som >= 2.5:
		if velocidade_final < 3.0 && velocidade_final >= 2.5:
			$Tween.interpolate_property($GameSound, "pitch_scale", 2.5, 3.0, 1, transition, Tween.EASE_IN_OUT)
			$Tween.start()
			$Snake2D/move_timer.wait_time = 0.05
			velocidade_final = 3.0

#Ocorre o tempo todo
func _process(delta):
	alterar()

#Terminar Tween
func terminou_tween(object, key):
	$GameSound.pitch_scale = velocidade_final
	pass