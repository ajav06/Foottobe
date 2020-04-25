extends Node2D


var tipos_saques = ["Pass the ball to\nany teanmate", 
					"Pass the ball to\nthe goalkeeper", 
					"Run up the\nclock",
					"Pass to a free\nplayer"]

func _ready():
	_cambiar_saque()
	$Footer/Time.text = "0:" + str(int($Timer.time_left))
	$Footer/Score.text = "%03d" % GlobalVar.score
	$Footer/Card.text = "%02d" % GlobalVar.yellow_card


func _process(delta):
	if(GlobalVar.yellow_card >= 2):
		$Timer.stop()
		GlobalVar.yellow_card = 0
		GlobalVar.score = 0
		get_tree().change_scene("res://src/scenes/Main.tscn")
		
	$Footer/Time.text = "00:%02d" % int($Timer.time_left)
	$Footer/Score.text = "%03d" % GlobalVar.score
	$Footer/Card.text = "%02d" % GlobalVar.yellow_card

func _cambiar_saque():
	randomize()
	$Question/Option_1/lbl.text = tipos_saques[0]
	$Question/Option_2/lbl.text = tipos_saques[1]
	$Question/Option_3/lbl.text = tipos_saques[2]
	$Question/Option_4/lbl.text = tipos_saques[3]
	#$Text.text = tipos_saques[randi() % tipos_saques.size()]

func _aumentar_score():
	_cambiar_saque()
	GlobalVar._aumentar_score_global(10)


func _on_Timer_timeout():
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_Btn_Question_pressed():
	$Btn_Question.visible = false
	$Question.visible = true


func _on_Btn_Exit_pressed():
	$Question.visible = false
	$Btn_Question.visible = true


func _on_Btn_home_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass


func _on_Option_1_pressed():
	_aumentar_score()
	pass # Replace with function body.


func _on_Option_2_pressed():
	GlobalVar._aumentar_tarjeta()
	pass # Replace with function body.

