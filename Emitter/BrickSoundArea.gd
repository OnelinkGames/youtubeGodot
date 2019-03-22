extends Area2D

#Criar Variaveis
var sound = false #Se o som irá mudar de volume ou não.
var circulo = 320 #Distancia que o som é audivel.
var sound_min = -10 #Minimo do som, quase inaudivel.

#Ao iniciar o jogo
func _ready():
	#Conecto o sinal de mouse in e mouse out na minha area, neste local poderia ser um personagem por exemplo in e out.
	connect("body_entered", self, "body_sound_entered")
	connect("body_exited", self, "body_sound_exited")
	#Deixo o som no menor volume possivel.
	$Brick1Sound.set_volume_db(-80)

#Ocorre o tempo todo no jogo
func _process(delta):
	# Se estiver na area de som daquele objeto o som fica verdadeiro.
	if sound == true:
		#Calcula a distancia do objeto no meio da area até onde o mouse esta.
		var distance = get_node("..").get_node("..").get_node("Personagem/KinematicBody2D").global_position.distance_to(get_global_position())
		#Calculo o som minimo e maximo dependendo da distancia (regra de 3)
		var audiosound = (distance * sound_min) / circulo
		# Para questão de Testes, imprimo o volume que esta saindo.
		print($Brick1Sound.get_volume_db())
		#Altero o volume atual.
		$Brick1Sound.set_volume_db(audiosound)
	pass

#Caso o mouse entre na area.
func body_sound_entered(body):
	if body.is_in_group("character"):
		#Se o som não estiver tocando, toca o som e muda a variavel que o som esta tocando para verdadeiro.
		sound = true

#Caso o mouse saia da area.
func body_sound_exited(body):
	if body.is_in_group("character"):
		#Diminui o volume do som para -80 (Menor valor possivel) *O som ainda fica tocando
		$Brick1Sound.set_volume_db(-80)
		#Muda a variavel de som tocando para falso.
		sound = false