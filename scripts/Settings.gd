extends Node2D

func _ready():
	pass

func _on_Back_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_Credits_pressed():
	get_tree().change_scene("res://scenes/Credits.tscn")
