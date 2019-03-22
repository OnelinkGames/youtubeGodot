extends StaticBody2D

#Variavel da area de detecção
var areaDetectavel = false

#Variavel de referencia com personagem
var objetoPersonagem

#Variavel de direção do inimigo
var direcaoInimigo = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar o AnimationPlayer quando terminar a animação
	$AnimationPlayer.connect("animation_finished", self, "animacaoTerminada")
	
	#Conectar entrar na area do personagem
	$areaInimigo.connect("body_entered", self, "entrouAreaPersonagem")
	
	#Conectar sair da area do personagem
	$areaInimigo.connect("body_exited", self, "saiuAreaPersonagem")

	#Conectar o fim do tempo de destruir
	$destroy_timer.connect("timeout", self, "destruir")
	
	#Iniciar animação do inimigo
	$AnimationPlayer.play("paradoEsquerda")
	pass # Replace with function body.

#Função para quando o personagem aparecer na linha de visão do Inimigo
func personagemAparece():
	if $AnimationPlayer.current_animation != "ataqueDireita" || $AnimationPlayer.current_animation != "ataqueEsquerda": #Verifica se a animação de ataque não está acontecendo
		if $Sprite.flip_h == false: #Verifica para qual lado ele esta virado.
			$AnimationPlayer.play("ataqueEsquerda") #Iniciar a animação de ataque
		else:
			$AnimationPlayer.play("ataqueDireita") #Iniciar a animação de ataque

#Para quando a animação terminar e não ficar travado.
func animacaoTerminada(anim):
	if anim == "ataqueDireita" || anim == "ataqueEsquerda": #Se a animação que terminou for a de Ataque
		if $Sprite.flip_h == false: #Verifica a direção do inimigo
			$AnimationPlayer.play("paradoEsquerda") #Inicia a animação parado
		else:
			$AnimationPlayer.play("paradoDireita") #Inicia a animação parado

#Função para detectar quando uma area entra no setor do inimigo
func entrouAreaPersonagem(body):
	if body.is_in_group("personagem"):
		objetoPersonagem = body #Salva a referencia em uma variavel
		body.objetoInimigo = self #Salva a referencia do inimigo no personagem
		areaDetectavel = true #Deixa o personagem detectavel

#Função para detectar quando uma area sai do setor do inimigo
func saiuAreaPersonagem(body):
	if body.is_in_group("personagem"):
		objetoPersonagem = null #Zera a referencia
		body.objetoInimigo = null #Zera a referencia
		areaDetectavel = false #Deixa o personagem não mais detectavel

#Função para checar o lado que o inimigo deve estar
func verificarLado(body):
	#Verifica a posição para descobrir o lado que o personagem está
	if body.position.x < position.x:
		virarPersonagem(false) #Vira ele para esquerda
	else:
		virarPersonagem(true) #Vira ele para a direita

#Função para virar o Inimigo
func virarPersonagem(dir):
	#Verificar a direção para alterar a variavel
	if dir:
		direcaoInimigo = 1
	else:
		direcaoInimigo = -1
	
	#Alterar a direção
	$Sprite.flip_h = dir

#Explodir
func explodir():
	#Desativar Colisores
	$bocaInimigo.monitoring = false
	set_physics_process(false)
	
	#Vai deixando a planta transparente e inicia a animação, depois toca o som de explodir
	$Tween.interpolate_property($Sprite, "modulate", Color(1,1,1,1), Color(1,1,1,0), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	$explodir.play()
	
	#Emite a particula.
	$Particles2D.emitting = true
	
	#Inicia o tempo para destruir o objeto
	$destroy_timer.start()
	
#Destruir o Inimigo
func destruir():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Verifica se personagem esta dentro da area e toca animação de ataque
	if areaDetectavel:
		personagemAparece() #realiza a animação de ataque
		if objetoPersonagem != null: #Se a referencia do objeto do personagem não for nula
			verificarLado(objetoPersonagem) #Verifica qual lado o inimigo deve ficar
	pass
