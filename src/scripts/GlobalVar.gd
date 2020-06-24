extends Node

var yellow_card = 0
var time_RedCard
var score = 0
var test = false

func _ready():
	yellow_card = 0;
	score = 0;
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _aumentar_score_global(new_score):
	score += new_score
	
	if score > Game.bestscore:
		Game.bestscore = score

func _aumentar_tarjeta():
	yellow_card +=1
	Game.yellowcard = 1
	
	if(yellow_card == 2):
		Game.redcard = 1
		_penalizacion()
		
func _penalizacion():
	time_RedCard = OS.get_datetime()
	time_RedCard["minute"] += 10
	
	if (time_RedCard["minute"] >= 50):
		time_RedCard["minute"] -= 60
		time_RedCard["hour"] += 1
		
	if(time_RedCard["hour"] == 24):
		time_RedCard["hour"] = 00
		time_RedCard["day"] += 1
		
	Game.timeRedCard = time_RedCard
	
