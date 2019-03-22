extends Node2D

#Carregar
onready var cena01 = preload("res://Cena01.tscn")
onready var cena02 = preload("res://Cena02.tscn")

#Variaveis
var cenaFinal
var cenas = false

func _ready():
	pass

func _process(delta):
	if Input.is_key_pressed(KEY_1) && cenas == false:
		cenaFinal = cena01.instance()
		add_child(cenaFinal)
		cenas = true
	
	if Input.is_key_pressed(KEY_2) && cenas == false:
		cenaFinal = cena02.instance()
		add_child(cenaFinal)
		cenas = true
	
	if Input.is_key_pressed(KEY_DELETE) && cenas == true:
		cenaFinal.queue_free()
		cenas = false
	pass
