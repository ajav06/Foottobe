extends Node2D


func _ready():
	pass

func _on_Settings_pressed():
	get_tree().change_scene("res://scenes/Settings.tscn")
