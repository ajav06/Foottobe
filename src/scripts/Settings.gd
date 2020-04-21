extends Node2D

func _ready():
	pass

func _on_Back_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")

func _on_Credits_pressed():
	get_tree().change_scene("res://src/scenes/Credits.tscn")
