extends Node2D

var time_now = 0
var limit = 0
var time_timer

func _ready():
	$Time.text = "00:00"
	_calcular_timer()
	$Score.text = "%03d" % Game.bestscore
	$Faild.text = "%02d / %02d" % [Game.redcard, Game.yellowcard]

func _process(delta):
	if($Timer.time_left <= 1):
		$Time.text = "00:00"
	
	elif($Timer.time_left >= 1):
		time_timer = str(stepify($Timer.time_left/60,0.01))
		time_timer = time_timer.split(".")
		print(time_timer)
		$Time.text = "%02d:%02d" % [float(time_timer[0]), float(time_timer[1])]

func _on_Settings_pressed():
	get_tree().change_scene("res://src/scenes/Settings.tscn")


func _on_Play_pressed():
	get_tree().change_scene("res://src/scenes/Throw-in.tscn")

func _calcular_timer():
	time_now = OS.get_datetime()
	limit = time_now
	
	if(time_now['month'] == Game.timeRedCard['month'] && time_now['day'] == Game.timeRedCard['day']):
		limit['hour'] = Game.timeRedCard['hour'] - time_now['hour']
		print(Game.timeRedCard)
		
		if(limit['hour'] < 0):
			$Timer.wait_time = 0
			
		elif(limit['hour'] == 0):
			limit['minute'] = Game.timeRedCard['minute'] - time_now['minute']
			limit['minute'] *=60
			limit['second'] = Game.timeRedCard['second'] - time_now['second'] + limit['minute']
			$Timer.wait_time = float(limit['second'])
			$Timer.start()
			print($Timer.wait_time)
			
		elif(limit['hour'] == 1):
			limit['minute'] = Game.timeRedCard['minute'] - time_now['minute'] + 50
			limit['minute'] *=60
			limit['second'] = Game.timeRedCard['second'] - time_now['second'] + limit['minute']
			$Timer.wait_time = float(limit['second'])
			$Timer.start()
			print($Timer.wait_time)
	
