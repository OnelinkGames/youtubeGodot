extends KinematicBody2D

#Referencias
var ghost = preload("res://cenas/Ghost.tscn")

#Variaveis
var velocidade = 100 #Velocidade do Personagem (Andar)
var pulo = -200 #Altura do Pulo
var vetor = Vector2() #Vetor de Movimento de Personagem
var gravidade = 300 #Gravidade para descer o personagem
var vetor_slide = Vector2(0, -1) #Vetor para Up do Move and Slide
var dir = 0 #Direção do Personagem
var dash = 150 #Distancia do Dash
var anim = false #Animação Extra
var raycast = 150 #Distancia do Raycast
var difespaco = 32 #Diferença do Espaço entre o meio do Raycast e a borda da colisão

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar o tween para quando acabar todas as animações
	$Tween.connect("tween_all_completed", self, "tween")
	
	#Conectar o tempo para criar a imagem fantasma
	$Timer.connect("timeout", self, "criarImagem")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Gravidade
	if !is_on_floor():
		vetor.y += gravidade * delta #Descer
	
	#Movimentar o personagem para a Direita
	if Input.is_action_pressed("ui_right"):
		$RayCast2D.cast_to = Vector2(raycast, 0) #Mudar raycast para direita
		vetor.x = 1 * velocidade #Mudar vetor para andar para direita
		dir = 1 #Mudar direção para direita
		$AnimatedSprite.flip_h = false #Mudar flip h para direita
		
		#Verifica se o personagem está no chão e a animação está falso
		if is_on_floor() and anim == false:
			$AnimatedSprite.play("andando") #Tocar animação andando
	
	#Movimentar o personagem para a Esquerda
	elif Input.is_action_pressed("ui_left"):
		$RayCast2D.cast_to = Vector2(-raycast, 0) #Mudar raycast para a esquerda
		vetor.x = -1 * velocidade #Mudar vetor para andar para esquerda
		dir = -1 #Mudar direção para esquerda
		$AnimatedSprite.flip_h = true #Mudar flip h para esquerda
		
		#Verifica se o personagem está no chão e a animação está falso
		if is_on_floor() and anim == false:
			$AnimatedSprite.play("andando") #Tocar animação andando
	else: #Caso não esteja andando para direita e nem para esquerda
		vetor.x = 0 #Zera velocidade
		
		#Verifica se o personagem está no chão e a animação está falso
		if is_on_floor() and anim == false:
			$AnimatedSprite.play("parado") #Toca animação parado
	
	#Caso apertar o Botão e estiver no chão executa o Pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		vetor.y = pulo #Altera o vetor para pular
		
		#Se animação estiver como falso
		if anim == false:
			$AnimatedSprite.play("pulando") #Toca animação de pulando
	
	#Caso apertar para cima executa o Dash
	if Input.is_action_just_pressed("ui_up"):
		anim = true #Transforma animação em true para travar outras animações
		$Timer.start() #Inicia tempo dos ghosts
		$AnimatedSprite.play("dash") #Toca a animação de dash
		
		#Verifica se o RayCast2D está colidindo com algum objeto
		if $RayCast2D.is_colliding():
			#Pega a distancia entre o objeto e a colisão
			var dif = get_position().distance_to($RayCast2D.get_collision_point()) 
			#Inicia o tween da posição do personagem do ponto atual até a distancia entre o personagem e a colisão
			$Tween.interpolate_property(self, "position", get_position(), Vector2(get_position().x + ((dif - difespaco) * dir), get_position().y), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
		else: #Caso não exista colisão
			#Inicia o tween da posição do personagem do ponto atual até a distancia do dash
			$Tween.interpolate_property(self, "position", get_position(), Vector2(get_position().x + (dash * dir), get_position().y), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
	
	#Move and Slide
	move_and_slide(vetor, vetor_slide)
	pass

#Função para retornar animação a falso quando acabar o dash
func tween():
	anim = false

#Função para criar as imagens fantasmas quando der o dash
func criarImagem():
	var fantasma = ghost.instance() #Instancia o ghost
	fantasma.position = position #Arruma a posição dele
	fantasma.alterar_lado($AnimatedSprite.flip_h) #Arruma o flip h dele
	get_owner().add_child(fantasma) #Adiciona ele em cena
	
	#Verifica se o dash está ocorrendo ainda e reinicia o timer.
	if anim == true:
		$Timer.start()