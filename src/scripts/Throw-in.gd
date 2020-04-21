extends Node2D


var tipos_saques = ["Top left", "Top right", "Center", "Bottom left"]
var score = 0
var yellow_card = 0

func _ready():
	_cambiar_saque()
	_collision_player_disabled(false)
	$Time.text = "0:" + str(int($Timer.time_left))
	$Score.text = str(score)
	$Card.text = "00"


func _process(delta):
	if(yellow_card >= 2):
		$Timer.stop()
		_collision_player_disabled(true)
		
	$Time.text = "0:" + str(int($Timer.time_left))
	$Score.text = str(score)
	$Card.text = "0" + str(yellow_card)

func _cambiar_saque():
	randomize()
	$Text.text = tipos_saques[randi() % tipos_saques.size()]

func _aumentar_score():
	_cambiar_saque()
	score += 10
	
	if score > Game.bestscore:
		Game.bestscore = score
		
func _aumentar_tarjeta():
	yellow_card +=1
	Game.yellowcard = 1
	
	if(yellow_card == 2):
		Game.redcard = 1
	
		
func _collision_player_disabled(val):
	$"Player-2_1/CollisionShape2D".disabled = val
	$"Player-2_2/CollisionShape2D".disabled = val
	$"Player-2_3/CollisionShape2D".disabled = val
	$"Player-2_4/CollisionShape2D".disabled = val


func _on_Player2_1_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Top left"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Top left"):
		_aumentar_tarjeta()


func _on_Player2_2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Top right"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Top right"):
		_aumentar_tarjeta()


func _on_Player2_3_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Bottom left"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Bottom left"):
		_aumentar_tarjeta()


func _on_Player2_4_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed && $Text.text == "Center"):
		_aumentar_score()
		
	elif(event is InputEventMouseButton && event.pressed && $Text.text != "Center"):
		_aumentar_tarjeta()


func _on_Timer_timeout():
	_collision_player_disabled(true)
