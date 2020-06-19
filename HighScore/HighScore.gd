extends Node2D

#Constantes
const PASSCODE = "12345678"
const URLCONSULTAR = "http://localhost/phpFiles/consultarHighScore.php"
const URLCADASTRAR = "http://localhost/phpFiles/cadastrarHighScore.php"
const URLMOSTRAR = "http://localhost/phpFiles/mostrarHighScore.php"

#Variaveis
var score
var nome

#Atalhos
onready var logText = $Log/ScrollContainer/Label
onready var scoreText = $Score/Panel/LineEdit
onready var scoreButton = $Score/Panel/Button
onready var nomeText = $Nome/Panel/LineEdit
onready var nomeButton = $Nome/Panel/Button
onready var scoreTableNomes = $ScoreTable/Panel/Nomes
onready var scoreTableScores = $ScoreTable/Panel/Score

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectando o HTTPRequest
	$HTTPRequest.connect("request_completed", self, "_on_HTTPRequest_request_completed")
	#Conectando o Button de Score
	scoreButton.connect("pressed", self, "_on_Button_pressed")
	#Conectando o Button do Nome
	nomeButton.connect("pressed", self, "_on_Button_pressed2")
	#Frase Inicial do Log
	logText.text = "Log de eventos:"
	pass # Replace with function body.

#Função para quanto completar o HTTPRequest
func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
	#Recuperar o valor da pagina e convertelo em JSON
	var json = JSON.parse(body.get_string_from_utf8())
	
	#Mostrar no log a atualização
	logText.text += "\nResultado do servidor = " + str(json.result)
	
	#Verificar retorno
	if typeof(json.result) == TYPE_STRING:
		if json.result == "Verdadeiro":
			aceitarHighScore()
		elif json.result == "Falso":
			negarHighScore()
		elif json.result == "mostrarForm":
			aparecerHighScore()
	else:
		mostrarHighScore(json.result)

#Função para aceitar HighScore após consulta
func aceitarHighScore():
	$Nome.visible = true #Deixa o outro form visivel
	scoreButton.disabled = true #Desativa o botão
	scoreText.editable = false #Desativa a LineEdit

#Função para negar HighScore após consulta
func negarHighScore():
	logText.text += "\nScore pequeno para aparecer no TOP 10" #Mostrar mensagem

#Função para mostrar o HighScore
func aparecerHighScore():
	#Envia a requisição com a variavel em GET
	$HTTPRequest.request(URLMOSTRAR)

#Função para montar e mostrar o HighScore
func mostrarHighScore(retorno):
	#Desabilitar Botão e Form
	nomeText.editable = false
	nomeButton.disabled = true
		
	#Deixar a lista visivel.
	$ScoreTable.visible = true
	
	#Rodar o texto e inserir na lista.
	for i in range(retorno.size() / 2):
		scoreTableNomes.text += "\n" + str(retorno.get("nome" + str(i)))
		scoreTableScores.text += "\n" + str(retorno.get("score" + str(i)))

#Ao apertar o botão do Score.
func _on_Button_pressed():
	score = scoreText.text #Recupera valor do texto
	#Envia a requisição com a variavel em POST
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var query = "code=" + PASSCODE + "&&score=" + score
	$HTTPRequest.request(URLCONSULTAR, headers, false, HTTPClient.METHOD_POST, query)
	#Mostrar mensagem no log
	logText.text = "Log de eventos:"
	logText.text += "\nValor enviado ao servidor = " + score

#Ao apertar o botão do Nome
func _on_Button_pressed2():
	nome = nomeText.text #Recupera valor do texto
	#Envia a requisição com a variavel em POST
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var query = "code=" + PASSCODE + "&&nome=" + nome + "&&score=" + score
	$HTTPRequest.request(URLCADASTRAR, headers, false, HTTPClient.METHOD_POST, query)
	#Mostrar mensagem no log
	logText.text += "\nValor enviado ao servidor = " + score + "-" + nome
