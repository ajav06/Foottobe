extends Node2D


#var tipos_saques = ["Pass the ball to\nany teammate", 
#					"Pass the ball to\nthe goalkeeper", 
#					"Run up the\nclock",
#					"Pass to a free\nplayer"]

var time = null
var score = null
var cards = null

var numero_preguntas_nivel = 10
var turn
#var user_ans 

# Cargamos nuestro fichero de preguntas en una variable.
onready var preguntas_del_nivel:Dictionary  = Game.load_data(Game.questions)

var correct_answer

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
   
#	conectar_botones()
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


func _on_Btn_home_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass
	
func _on_Option_1_pressed():
	_prompt_if_pressed($Question/Options.get_child(0).get_meta("answer"))
	pass # Replace with function body.

func _on_Option_2_pressed():
	_prompt_if_pressed($Question/Options.get_child(1).get_meta("answer"))
	pass # Replace with function body.

func _on_Option_3_pressed():
	_prompt_if_pressed($Question/Options.get_child(2).get_meta("answer"))
	pass # Replace with function body.
	
func _on_Option_4_pressed():
	_prompt_if_pressed($Question/Options.get_child(3).get_meta("answer"))
	

func _prompt_if_pressed(user_ans):

	$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true

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

func _on_Btn_Back_pressed():
	$Background.visible = false
	$Players.visible = true
	$Question.visible = false
	$Btn_Back.visible = false
	$Btn_Question.visible = true
	$Footer.visible = true
	$Answer_Window.visible = false

func carga_pregunta():
	# Asigna la pregunta almacenada en el índice correspondiente al turn en juego
	var pregunta_actual = elige_pregunta(indices[turn])
	

	# creamos botones aleatorios
	var botones_random = $Question/Options.get_children()
	randomize() # actualizamos la semilla
	botones_random.shuffle() # barajamos los botones

	
	# actualizamos los nodos con los datos asignados
	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"] # La pregunta   
	botones_random[0].get_node("lbl").text = pregunta_actual["respA"]
	#botones_random[0] = int($Question/Options/Option_1/lbl_pos.text)
	botones_random[0].set_meta("answer", 0)
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
	
#	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"]
#	$Question/Options/Option_1/lbl.text = pregunta_actual["respA"]
#	$Question/Options/Option_2/lbl.text = pregunta_actual["respB"]
#	$Question/Options/Option_3/lbl.text = pregunta_actual["respC"]
#	$Question/Options/Option_4/lbl.text = pregunta_actual["respD"]
	
	correct_answer = pregunta_actual["buena"]

#func option_pressed():
#	var a
#	a =  int($Question/Options/Option_1/lbl_pos.text)
#	print(a)
#	if(a == 1):
#		print('works')
#	else:
#		print('doesnt work')
#	if(botones_random[0]):
#		user_ans = 0
#	elif(botones_random[1]):
#		user_ans = 1
#	elif(botones_random[2]):
#		user_ans = 2
#	elif(botones_random[3]):
#		user_ans = 3
#		print(user_ans)
#	return user_ans		

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
			
func _on_Btn_Next_pressed():
	pass # Replace with function body.
 
func salir():
	get_tree().change_scene("res://src/scenes/Main.tscn")


	
