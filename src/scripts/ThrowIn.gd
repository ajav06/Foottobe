extends Node2D


#var tipos_saques = ["Pass the ball to\nany teammate", 
#					"Pass the ball to\nthe goalkeeper", 
#					"Run up the\nclock",
#					"Pass to a free\nplayer"]

var time = null
var score = null
var cards = null
var user_ans=-1
var numero_preguntas_nivel = 10
var turn
#var user_ans 

# Cargamos nuestro fichero de preguntas en una variable.
onready var preguntas_del_nivel:Dictionary  = Game.load_data(Game.questions)
onready var promt_tween=$Tween
var correct_answer
#var answers
#var translations
# Arrays 
var indices:Array = [] # Aquí almacenaremos todos los números de pregunta, las "key" del diccionario.

class Question:
	var _answers = []
	var _translations = []
	var _correct_index = -1
	var _shuffled = []

	func _init(json_stuff):
		_answers = json_stuff["answers"]
		_translations = json_stuff["translations"]
		_correct_index = json_stuff["correct"]
		_shuffle()

	func _shuffle():
		_shuffled.clear()
		for i in range(_answers.size()):
			var entry = {}
			entry["answer"] = _answers[i]
			entry["translation"] = _translations[i]
			entry["correct"] = i == _correct_index
			_shuffled.append(entry)
		_shuffled.shuffle()

	func is_answer_correct(index):
		return _shuffled[index]["correct"]

	func get_shuffled_answer(index):
		return _shuffled[index]["answer"]
		
	func get_shuffled_translation(index):
		return _shuffled[index]["translation"]

	func print_me():
		print(_answers)
		print(_translations)
		print(_correct_index)
		for i in range(_shuffled.size()):
			print(_shuffled[i])

func _ready():
	if preguntas_del_nivel.empty():
		salir()
	inicializar()
	time = "0:" + str(int($Timer.time_left))
	score = "%03d" % GlobalVar.score
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()

func inicializar():
	var numero_preguntas_disponibles = contar_indices()

	if numero_preguntas_disponibles < numero_preguntas_nivel:
		salir()
	turn = 0

#	randomize() # Actualiza la semilla para generar aleatorios.
#	indices.shuffle() # Barajea aleatoriamente el array de indices.
   
	#conectar_botones()
#	option_pressed()
	carga_pregunta()

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


#func _cambiar_saque():
#	randomize()
#	$Question/Option_1/lbl.text = tipos_saques[0]
#	$Question/Option_2/lbl.text = tipos_saques[1]
#	$Question/Option_3/lbl.text = tipos_saques[2]
#	$Question/Option_4/lbl.text = tipos_saques[3]
	#$Text.text = tipos_saques[randi() % tipos_saques.size()]


func _aumentar_score():
#	_cambiar_saque()
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
	$Before_Answer.visible = false


func _on_Btn_home_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass
	
func _on_Option_1_pressed():
	user_ans = $Question/Options.get_child(0).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.

func _on_Option_2_pressed():
	user_ans = $Question/Options.get_child(1).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.

func _on_Option_3_pressed():
	user_ans = $Question/Options.get_child(2).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.
	
func _on_Option_4_pressed():
	user_ans = $Question/Options.get_child(3).get_meta("answer")
	_prompt_and_check()
	
func _prompt_and_check():
	$Before_Answer.visible = true

func _on_Btn_Yes_pressed():
	$Before_Answer.visible = false
	#$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true

	print('it workssss I guess')
	if(user_ans==correct_answer):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		_aumentar_score()
		print('it works')
		get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta!."
		#get_tree().reload_current_scene()
	else:
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		GlobalVar._aumentar_tarjeta()
		get_node("Answer_Window/proceed_label").text="¡Respuesta Incorrecta!."
		print('doesnt work')
	 
	if turn < numero_preguntas_nivel-1:
		turn += 1 # 
		get_tree().change_scene("")
		carga_pregunta()
	else:
		print('Game Over')
	
	
func _on_Btn_No_pressed():
	$Before_Answer.visible = false
	$Answer_Window.visible = false
	$Question.visible = true
	#$Before_Answer/translation.text = ''
	pass # Replace with function body.
	
	"""
func al_responder(boton):
	var test = false
   
	# comprobamos si es el boton correcto
	if boton.text == 'Yes':
		test = true
	else:
	   print('no se')
	return test
	"""

	"""
func _prompt_if_pressed(user_ans):

	$Before_Answer.visible = true
	#$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true

	if(al_responder(boton)):

		print('it workssss I guess')
		if(user_ans==correct_answer):
			_aumentar_score()
			print('it works')
			get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta!."
			#get_tree().reload_current_scene()
		else:
			GlobalVar._aumentar_tarjeta()
			get_node("Answer_Window/proceed_label").text="¡Respuesta Incorrecta!."
			print('doesnt work')
	 
		# comprobamos si es el final del juego
		if turn < numero_preguntas_nivel-1:
			turn += 1 # pasamos a otra pregunta
			get_tree().change_scene("")
			carga_pregunta()
		else:
			print('Game Over')
	else:
		print('FF')
		"""
		
func _on_Btn_Back_pressed():
	$Background.visible = false
	$Players.visible = true
	$Question.visible = false
	$Btn_Back.visible = false
	$Btn_Question.visible = true
	$Footer.visible = true
	$Answer_Window.visible = false

func carga_pregunta():
	
	var pregunta_actual = elige_pregunta(indices[turn])
	var question = Question.new(pregunta_actual)
	#button1.set_text(question.get_shuffled_answer(0))
	#button2.set_text(question.get_shuffled_answer(1))
	question.print_me()
	#var shuffled_indexes = []

	#answers = pregunta_actual["answers"]
	#translations = pregunta_actual["translations"]


func elige_pregunta(id_pregunta:String):
	# Comprobamos si el índice existe.
	if preguntas_del_nivel.has(id_pregunta):
		return preguntas_del_nivel[id_pregunta] # Si el índice existe, devuelve el diccionario que almacena.
	else:
		print('error')
		return {} # Si no existe, devuelve vacío.
		 
func contar_indices():
	# Cargamos en el array indices todos los numeros de pregunta 1,2,3,...
	indices = preguntas_del_nivel.keys()
	return indices.size() 


#func connect_buttons():
#	var buttons = $Question/Options.get_children() # Captura los hijos del nodo respuestas
#	for button in buttons:
#		if button is TextureButton: # Comprueba si cada hijo es del tipo Button
#			# conectamos la señal PRESSED con la funcion AL_RESPONDER y pasamos el boton como parametro
#			button.connect("pressed",self,"_prompt_if_pressed")
"""
func conectar_botones():
	var botones = $Before_Answer/Opt.get_children() # Captura los hijos del nodo respuestas
	for boton in botones:
		if boton is Button: # Comprueba si cada hijo es del tipo Button
			# conectamos la señal PRESSED con la funcion AL_RESPONDER y pasamos el boton como parametro
			boton.connect("pressed",self,"al_responder",[boton])
			"""
			
func _on_Btn_Next_pressed():
	pass # Replace with function body.
 
func salir():
	get_tree().change_scene("res://src/scenes/Main.tscn")

