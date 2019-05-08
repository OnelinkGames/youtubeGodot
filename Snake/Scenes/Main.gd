extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	#Conectar botão
	$Button.connect("pressed", self, "button_pressed")
	pass # Replace with function body.

#Ao Apertar Botão
func button_pressed():
	get_tree().change_scene("res://Scenes/Game.tscn")