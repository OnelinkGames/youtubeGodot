extends Control

#Referencias
onready var botao = $Jogar
onready var direitaLine = $DireitaMostrar
onready var esquerdaLine = $EsquerdaMostrar
onready var puloLine = $PuloMostrar

#Variaveis
var button #Referencia ao event gerado
var button_key = 0 #Texto do event gerado
var direita #Guardar a tecla direita pressionada
var esquerda #Guardar a tecla esquerda pressionada
var pulo #Guardar a tecla de pulo pressionada

#Realiza as conexões de apertar o botão e focus das caixas de texto.
func _ready():
	botao.connect("pressed", self, "button_ready")
	direitaLine.connect("focus_entered", self, "DireitaFocus")
	esquerdaLine.connect("focus_entered", self, "EsquerdaFocus")
	puloLine.connect("focus_entered", self, "PuloFocus")
	
	#Limpa o InputMap e Cria novamente.
	InputMap.erase_action("direita")
	InputMap.erase_action("esquerda")
	InputMap.erase_action("pulo")
	InputMap.add_action("direita")
	InputMap.add_action("esquerda")
	InputMap.add_action("pulo")
	pass

func _process(delta):
	#Verifica se uma das caixas tem foco e grava nela o valor da tecla pressionada, além de atualizar a variavel com o evento de tecla gerado.
	if direitaLine.has_focus():
		direitaLine.text = str(button_key)
		direita = button
	elif esquerdaLine.has_focus():
		esquerdaLine.text = str(button_key)
		esquerda = button
	elif puloLine.has_focus():
		puloLine.text = str(button_key)
		pulo = button
	pass

#Evento de input.
func _input(event):
	#Verifica se o evento é de teclado e retorna o que foi apertado nas variaveis.
	if event is InputEventKey:
		if event.is_pressed() and not event.is_echo():
			button_key = event.get_scancode()
			button = event
	#Verifica se o evento é de joypad e retorna o que foi apertado nas variaveis.
	if event is InputEventJoypadButton:
		if event.is_pressed():
			button_key = event.get_button_index()
			button = event

#Funcão de quando o botão é apertado, grava as teclas no InputMap e carrega a tela inicial.
func button_ready():
	InputMap.action_add_event("direita", direita)
	InputMap.action_add_event("esquerda", esquerda)
	InputMap.action_add_event("pulo", pulo)
	get_tree().change_scene("res://Principal.tscn")

#Função para limpar o campo quando entrar em focus.
func DireitaFocus():
	button = null
	button_key = 0

#Função para limpar o campo quando entrar em focus.
func EsquerdaFocus():
	button = null
	button_key = 0

#Função para limpar o campo quando entrar em focus.
func PuloFocus():
	button = null
	button_key = 0