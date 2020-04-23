extends Node2D
var date

func _ready():
	pass 

func _on_Button_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass
