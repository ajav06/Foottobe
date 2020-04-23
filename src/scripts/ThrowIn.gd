extends Node2D


var tipos_saques = ["Top left", "Top right", "Center", "Bottom left"]

func _ready():
	_cambiar_saque()
	_collision_player_disabled(false)
	$Header/Time.text = "0:" + str(int($Timer.time_left))
	$Header/Score.text = "%03d" % GlobalVar.score
	$Header/Card.text = "%02d" % GlobalVar.yellow_card


func _process(delta):
	if(GlobalVar.yellow_card >= 2):
		$Timer.stop()
		_collision_player_disabled(true)
		
	$Header/Time.text = "00:%02d" % int($Timer.time_left)
	$Header/Score.text = "%03d" % GlobalVar.score
	$Header/Card.text = "%02d" % GlobalVar.yellow_card

func _cambiar_saque():
	randomize()
	#$Text.text = tipos_saques[randi() % tipos_saques.size()]

func _aumentar_score():
	_cambiar_saque()
	GlobalVar._aumentar_score_global(10)


func _collision_player_disabled(val):
	pass


func _on_Player2_1_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Top left"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Top left"):
		GlobalVar._aumentar_tarjeta()


func _on_Player2_2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Top right"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Top right"):
		GlobalVar._aumentar_tarjeta()


func _on_Player2_3_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Bottom left"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Bottom left"):
		GlobalVar._aumentar_tarjeta()


func _on_Player2_4_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Center"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Center"):
		GlobalVar._aumentar_tarjeta()


func _on_Timer_timeout():
	_collision_player_disabled(true)
