extends KinematicBody2D

#Constantes
const GRAVITY = 300
const UP = Vector2(0, -1)
const SPEED = 100
const JUMP = 180   
const CAMERA = -50

#Variaveis
var motion = Vector2()
var dir = 1
var colisorDano = false #Para verificar o colisor de dano
var cameraOffset = -50
var hp = 100 #Quantidade de HP

#Variavel que guarda referencia do Inimigo
var objetoInimigo

#Sinais
signal levarDano
signal aumentarScore

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar a Area2d que vai detectar se o Personagem colidiu com o Inimigo
	$areaDano.connect("area_entered", self, "_on_areaDano_area_entered")
	
	#Conectar areaBater Entrar
	$areaBater.connect("area_entered", self, "_on_areaBater_area_entered")
	
	#Conectar areaBater Sair
	$areaBater.connect("area_exited", self, "_on_areaBater_area_exited")
	
	#Conectar Timer
	$tempoMorrer.connect("timeout", self, "tempoMorrer")
	
	#Iniciar animação
	$AnimationPlayer.play("parado")
	
	#Camera Offset
	$Camera2D.offset.y = cameraOffset
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#Gravidade
	if !is_on_floor():
		motion.y += GRAVITY * delta
	
	#Mover
	if Input.is_action_pressed("ui_right"):
		dir = 1
		$Sprite.flip_h = false
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("andando")
	elif Input.is_action_pressed("ui_left"):
		dir = -1
		$Sprite.flip_h = true
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("andando")
	else:
		dir = 0
		motion.x = SPEED * dir
		if is_on_floor():
			$AnimationPlayer.play("parado")
	
	#Pular
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor(): #Condição no solo
			motion.y = -JUMP
			$AnimationPlayer.play("pulando")
			$pulo.play()
	
	#Animação de Cair
	if !is_on_floor():
		if motion.y > 0:
			if $AnimationPlayer.current_animation == "pulando":
				$AnimationPlayer.play("caindo")
	
	#Camera
	$Camera2D.offset.y = cameraOffset
	
	#Abaixar Camera
	if cameraOffset <= 0 && cameraOffset >= -50:
		if Input.is_action_pressed("ui_down"):
			cameraOffset += 1
	
	#Levantar Camera
	if cameraOffset <= -50 && cameraOffset >= -100:
		if Input.is_action_pressed("ui_up"):
			cameraOffset -= 1
	
	#Camera Offset
	if cameraOffset != CAMERA:
		if !Input.is_action_pressed("ui_down") && !Input.is_action_pressed("ui_up"):
			if cameraOffset > CAMERA:
				cameraOffset -= 1
			else:
				cameraOffset += 1
	
	#Realizar Fisica
	move_and_slide(motion, UP)
	
	#Morrer se o hp for menor ou igual a zero
	if hp <= 0:
		morrer()
	pass

#Função para quando o personagem morrer
func morrer():
	$Particles2D.emitting = true #Emite as particulas
	$Sprite.visible = false #Deixa o sprite invisivel
	$tempoMorrer.start() #Inicia o tempo de reiniciar a tela
	set_physics_process(false) #Desabilita a fisica

#Quando acabar o tempo reinicia a tela.
func tempoMorrer():
	get_tree().reload_current_scene()

#Checa se o colisor de dano encostou no inimigo
func _on_areaBater_area_entered(area):
	if area.is_in_group("inimigo"): #Verifica se a Area colidida é o inimigo
		colisorDano = true

func _on_areaBater_area_exited(area):
	if area.is_in_group("inimigo"): #Verifica se a Area colidida é o inimigo
		colisorDano = false

#Colisão com o Inimigo
func _on_areaDano_area_entered(area):
	if area.is_in_group("inimigo"): #Verifica se a Area colidida é o inimigo
		if $tempo_invencivel.time_left == 0: #Verifica se o tempo de invencibilidade é 0
			if colisorDano == false:
				$tempo_invencivel.start() #Inicia o tempo de invencibilidade
				tomou_dano() #Toma Dano
				hp -= 10 #Reduz hp do personagem
				emit_signal("levarDano", 10) #Manda signal para a GUI
			else:
				area.get_owner().call_deferred("explodir") #Chama a função no tempo de espera
				motion.y = -(JUMP / 2) #Da um mini pulo
				$pulo.play() #Toca o som
				emit_signal("aumentarScore", 50) #Envia signal para a GUI

#Função para realizar a animação de dano do personagem
func tomou_dano():
	#Tweens Padrões, não mudam
	$Tween.interpolate_property($Sprite, "modulate", Color(0.55, 0, 0, 1), Color(1, 1, 1, 1), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Sprite, "scale", Vector2(0.5, 0.5), Vector2(1, 1), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	
	#Verificar direção do inimigo
	if objetoInimigo != null:
		if objetoInimigo.direcaoInimigo == -1:
			$Tween.interpolate_property(self, "position", null, Vector2(position.x - 30, position.y), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
		else:
			$Tween.interpolate_property(self, "position", null, Vector2(position.x + 30, position.y), .5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	#Iniciar o Tween
	$dano.play()
	$Tween.start()
