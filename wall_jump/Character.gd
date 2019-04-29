extends KinematicBody2D

#Variaveis
var sliding = false #Verificar se o personagem está escorregando na parede ou não
var velocity = Vector2() #Vetor de velocidade x e y do personagem
var speed = 200 #Velocidade x do personagem
var jump = -300 #Altura do pulo do personagem
var gravity = 500 #Gravidade padrão do personagem sem deslizar na parede.
var wall_gravity = 50 #Gravidade deslizando na parede
var wall_jump = -200 #Altura que o personagem subira ao fazer um wall_kick
var wall_kick = 300 #Distancia que o personagem irá no eixo x ao fazer um wall kick
var dir = 0 #Direção que o personagem está, direita ou esquerda.
var wall = false #Variavel para verificar se o personagem está na parede ou não.
var movement = true #Variavel para verificar se personagem está se movendo

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar o tempo de resposta do personagem.
	$hab_timer.connect("timeout", self, "time_is_over")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#Ocorre o tempo todo
func _physics_process(delta):
	#Verifica se o personagem está na parede e não no chão e aplica a gravidade da parede.
	if velocity.y >= 0:
		if is_on_wall() && !is_on_floor():
			velocity.y += wall_gravity * delta #Gravidade da parede
			sliding = true #Variavel como true para indicar que ele esta deslizando na parede.
		else:
			#Caso ele não esteja na parede nem no chão, gravidade normal
			if !is_on_wall() && !is_on_floor():
				velocity.y += gravity * delta #Gravidade normal
				sliding = false #Não está escorregando na parede
			#Caso ele esteja no chão
			elif is_on_floor():
				sliding = false #Não está escorregando na parede
	else:
		velocity.y += gravity * delta #Gravidade normal
	
	#Se ele estiver deslizando na parede e estiver andando para direita ao apertar a direção contraria
	if sliding && dir == 1 && Input.is_action_just_pressed("ui_accept"):
		print("Left Wall Jump") #Mostra que ele faz um wall jump
		movement = false #Desabilita o movimento do personagem
		$hab_timer.start() #Inicia o tempo de habilitar novamente o movimento do personagem.
		velocity.y = wall_jump #Da um pequeno pulo no eixo y com o wall_jump
		velocity.x = -wall_kick #Da um pequeno movimento no eixo x com o wall kick
		sliding = false #Personagem não está mais escorregando
	#Se ele estiver deslizando na parede e estiver andando para esquerda ao apertar a direção contraria
	elif sliding && dir == -1 && Input.is_action_just_pressed("ui_accept"):
		print("Right Wall Jump") #Mostra que ele faz um wall jump
		movement = false #Desabilita o movimento do personagem
		$hab_timer.start() #Inicia o tempo de habilitar novamente o movimento do personagem.
		velocity.y = wall_jump #Da um pequeno pulo no eixo y com o wall_jump
		velocity.x = wall_kick #Da um pequeno movimento no eixo x com o wall kick
		sliding = false #Personagem não está mais escorregando
	
	#Verifica se a variavel movimento esta habilitada e movimento o personagem, codigo basico
	if movement:
		if Input.is_action_pressed("ui_left"):
			dir = -1
			velocity.x = dir * speed
		elif Input.is_action_pressed("ui_right"):
			dir = 1
			velocity.x = dir * speed
		else:
			dir = 0
			velocity.x = dir * speed
	
	#Verifica se o personagem esta andando para direita ou esquerda 
	#se esta na parede e se a variavel de colisão na parede esta falsa
	if dir != 0 && is_on_wall() && wall == false:
		wall = true #Transforma a variavel em verdadeiro
		velocity.y = 0 #Zera a velocidade y
	#Verifica se o personagem está andando para direita ou esquerda
	#se não está na parede e se a variavel de colisão na parede esta verdadeira
	if dir != 0 && !is_on_wall() && wall:
		wall = false #Transforma a variavel em falso
	
	#Movimentar o personagem
	move_and_slide(velocity, Vector2(0, -1))
	
	#Verifica se o botão de pulo foi apertado com o personagem estando no chão 
	#e não estando na parede
	if Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = jump #Pula normal com o jump

#Função para quando acabar o tempo de habilitação de movimento do personagem
func time_is_over():
	movement = true #Altera a variavel de movimento para verdadeiro