extends Node2D


func _ready():
	$Score.text = str(Game.bestscore)
	$Faild.text = str(Game.redcard) + "/" + str(Game.yellowcard)

func _on_Settings_pressed():
	get_tree().change_scene("res://src/scenes/Settings.tscn")


func _on_Play_pressed():
	get_tree().change_scene("res://src/scenes/Throw-in.tscn")
