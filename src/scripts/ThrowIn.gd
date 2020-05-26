extends Node2D

var tipos_saques = ["Pass the ball to\nany teanmate", 
					"Pass the ball to\nthe goalkeeper", 
					"Run up the\nclock",
					"Pass to a free\nplayer"]
var time = null
var score = null
var cards = null


func _ready():
	_cambiar_saque()
	time = "0:" + str(int($Timer.time_left))
	score = "%03d" % GlobalVar.score
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()

func _process(delta):
	if(GlobalVar.yellow_card >= 2):
		$Timer.stop()
		GlobalVar.yellow_card = 0
		GlobalVar.score = 0
		get_tree().change_scene("res://src/scenes/Main.tscn")
	
	time = "00:%02d" % int($Timer.time_left)
	score = "%03d" % GlobalVar.score
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()


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


func _assign_text():
	$Footer/Time.text = time
	$Footer/Score.text = score
	$Footer/Card.text = cards
	
	$Question/Time.text = time
	$Question/Score.text = score
	$Question/Card.text = cards


func _on_Timer_timeout():
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_Btn_Question_pressed():
	$Players.visible = false
	$Background.visible = true
	$Btn_Question.visible = false
	$Question.visible = true
	$Btn_Back.visible = true
	$Footer.visible = false


func _on_Btn_home_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass

func _on_Option_1_pressed():
	_aumentar_score()
	$answer.visible = true
	$Question.visible = false
	pass # Replace with function body.

func _on_Option_2_pressed():
	GlobalVar._aumentar_tarjeta()
	pass # Replace with function body.

func _on_Option_3_pressed():
	GlobalVar._aumentar_tarjeta()
	pass # Replace with function body.
	
func _on_Option_4_pressed():
	GlobalVar._aumentar_tarjeta()
	pass # Replace with function body.
	

func _on_Btn_Back_pressed():
	$Background.visible = false
	$Players.visible = true
	$Question.visible = false
	$Btn_Back.visible = false
	$Btn_Question.visible = true
	$Footer.visible = true
	$answer.visible = false

