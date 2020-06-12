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
var answers
var translations
# Arrays 
var indices:Array = [] # Aquí almacenaremos todos los números de pregunta, las "key" del diccionario.

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
	var shuffled_indexes = []

	#var json_data_template = dialog_json["Template"]

	#var answers = json_data_template["answers"]
	answers = pregunta_actual["answers"]
	translations = pregunta_actual["translations"]

	for i in range(answers.size()):
		shuffled_indexes.append(i)
	shuffled_indexes.shuffle()

	var buttons = $Question/Options.get_children()
	#var test1 =
	#var translation = $Before_Answer/Opts.get_children()
	for i in range(buttons.size()):
		var shuf_index = shuffled_indexes[i]
		buttons[shuf_index].get_node("lbl").text = answers[shuf_index]
		#buttons[0].get_node("translation").text = translations[shuf_index]
		$Before_Answer/translation.text = translations[shuf_index]
		#$Before_Answer/translation2.text = translations[shuf_index]
		#$Before_Answer/translation3.text = translations[shuf_index]
		#$Before_Answer/translation4.text = translations[shuf_index]


		"""
		print(i)
		if(buttons[0]):
			$Before_Answer/translation.text = translations[shuf_index]
			$Before_Answer/translation.visible = true
			print('hola')
		elif(buttons[2]):
			$Before_Answer/translation2.text = translations[shuf_index]
			$Before_Answer/translatio2.visible = true
			print('no')
		elif(buttons[3]):
			$Before_Answer/translation3.text = translations[shuf_index]
			$Before_Answer/translation3.visible = true
		elif(buttons[4]):
			$Before_Answer/translation4.text = translations[shuf_index]
			$Before_Answer/translation4.visible = true
		else:
			print('didnt work')
			"""
		#buttons[shuf_index].get_node("translation").text = translations[shuf_index]
		#$Before_Answer/translation.text = translations[shuf_index]
		#$Before_Answer/translation2.text = translations[shuf_index]
		#$Before_Answer/translation3.text = translations[shuf_index]
		#$Before_Answer/translation4.text = translations[shuf_index]
		#buttons[shuf_index].get_node("translation").text = translations[shuf_index]
		#test1[shuf_index].get_node("translation").text = translations[shuf_index]
		#test1[shuf_index].get_node("translation2").text = translations[shuf_index]
		#test1[shuf_index].get_node("translation3").text = translations[shuf_index]
		#test1[shuf_index].get_node("translation4").text = translations[shuf_index]

	#var test1 = $Before_Answer/translation.text
	#var test1 =
	#for i in range(test1.size()):
	#	var shuf_index = shuffled_indexes[i]
	#	buttons[shuf_index].get_node("lbl").text = answers[shuf_index]
		"""
	var test = $Before_Answer.get_children()
	for i in range(buttons.size()):
		var shuf_index = shuffled_indexes[i]
		#buttons[shuf_index].get_node("lbl").text = answers[shuf_index]
		buttons[shuf_index].get_node("translation").text = translations[shuf_index]
		"""

		"""
	$Before_Answer/translation.text = pregunta_actual["translationA"]
	var buttons = $Before_Answer/translation.text 
	for i in range(buttons.size()):
		var shuf_index = shuffled_indexes[i]
		buttons[shuf_index].get_node("lbl").text = answers[shuf_index]
		"""

	"""
	# Asigna la pregunta almacenada en el índice correspondiente al turn en juego
	var pregunta_actual = elige_pregunta(indices[turn])
	

	# creamos botones aleatorios
	var botones_random = $Question/Options.get_children()
	randomize() # actualizamos la semilla
	botones_random.shuffle() # barajamos los botones
	"""

	"""
	# actualizamos los nodos con los datos asignados
	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"] # La pregunta   
	botones_random[0].get_node("lbl").text = pregunta_actual["respA"]
	#botones_random[0] = int($Question/Options/Option_1/lbl_pos.text)
	botones_random[0].set_meta("answer", 0)
	#botones_random[0].get_node("lbl").text = pregunta_actual["respA"]
	print(botones_random[0])
	botones_random[1].get_node("lbl").text = pregunta_actual["respB"]
#	botones_random[1] = int($Question/Options/Option_2/lbl_pos.text)
	botones_random[1].set_meta("answer", 1)
	print(botones_random[1])
	botones_random[2].get_node("lbl").text = pregunta_actual["respC"]
	botones_random[2].set_meta("answer", 2)
#	botones_random[2] = int($Question/Options/Option_3/lbl_pos.text)
	print(botones_random[2])
	botones_random[3].get_node("lbl").text = pregunta_actual["respD"]
	botones_random[3].set_meta("answer", 3)
#	botones_random[3] = int($Question/Options/Option_4/lbl_pos.text)
	print(botones_random[3])
	"""
#	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"]
#	$Question/Options/Option_1/lbl.text = pregunta_actual["respA"]
#	$Question/Options/Option_2/lbl.text = pregunta_actual["respB"]
#	$Question/Options/Option_3/lbl.text = pregunta_actual["respC"]
#	$Question/Options/Option_4/lbl.text = pregunta_actual["respD"]
	
	#correct_answer = pregunta_actual["buena"]
	#translation_c_answer = pregunta_actual["translationA"]
	#$Before_Answer/translation.text = pregunta_actual["translationA"]
	"""
	if(botones_random[0]):
		$Before_Answer/translation.text = pregunta_actual["translationA"]
	elif(botones_random[1]):
		$Before_Answer/translation.text = pregunta_actual["translationB"]
	elif(botones_random[2]):
		$Before_Answer/translation.text = pregunta_actual["translationC"]
	elif(botones_random[3]):
		$Before_Answer/translation.text = pregunta_actual["translationD"]
		"""


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

