extends Node2D

var time_now = 0
var limit = 0
var time_timer

func _ready():
	$Home/Time.text = "00:00"
	_calcular_timer()
	$Home/Score.text = "%03d" % Game.bestscore
	$Home/Faild.text = "%02d / %02d" % [Game.redcard, Game.yellowcard]

func _process(_delta):
	if($Timer.time_left <= 1):
		$Home/Time.text = "00:00"
		$Play.disabled = false
	
	elif($Timer.time_left >= 1):
		$Play.disabled = true
		time_timer = int($Timer.time_left)
		$Home/Time.text = "%02d:%02d" % [time_timer/60, time_timer%60]


func _calcular_timer():
	"""
	time_now = OS.get_datetime()
	limit = time_now
	$Timer.wait_time = 0
	
	if(time_now['month'] == Game.timeRedCard['month'] && time_now['day'] == Game.timeRedCard['day']):
		limit['hour'] = Game.timeRedCard['hour'] - time_now['hour']
			
		if(limit['hour'] == 0):
			limit['minute'] = Game.timeRedCard['minute'] - time_now['minute']
			limit['minute'] *=60
			limit['second'] = Game.timeRedCard['second'] - time_now['second'] + limit['minute']
			$Timer.wait_time = float(limit['second'])
			$Timer.start()
			
		elif(limit['hour'] == 1):
			limit['minute'] = 60 - time_now['minute'] + Game.timeRedCard['minute']
			limit['minute'] *=60
			limit['second'] = Game.timeRedCard['second'] - time_now['second'] + limit['minute']
			$Timer.wait_time = float(limit['second'])
			$Timer.start()
			print('HOla bb')
	"""		


func _on_Exit_pressed():
	get_tree().quit()
	pass

func _on_Play_pressed():
	get_tree().change_scene("res://src/scenes/Throw-in.tscn")

func _on_Settings_pressed():
	get_tree().change_scene("res://src/scenes/Settings.tscn")

func _on_Search_pressed():
	$CanvasLayer/HTTPRequest.request("http://foottobe.herokuapp.com/api/glosario")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var glosario = JSON.parse(body.get_string_from_utf8()).result
	var escena = load("res://src/scenes/Glossary.tscn")
	var g = escena.instance()
	var lista_p = g.get_node("Glossary/ScrollContainer/HBoxContainer/VBPalabra")	
	var lista_s = g.get_node("Glossary/ScrollContainer/HBoxContainer/VBSignificado")
	for palabra in glosario['glosario']:
		var p = Label.new()
		p.set_text(palabra['palabra'])
		p.set_align(1)
		lista_p.add_child(p)
		var s = Label.new()
		s.set_text(palabra['significado'])
		s.set_align(1)
		lista_s.add_child(s)
	$".".add_child(g)
