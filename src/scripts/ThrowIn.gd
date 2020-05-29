extends Node2D


#var tipos_saques = ["Pass the ball to\nany teammate", 
#					"Pass the ball to\nthe goalkeeper", 
#					"Run up the\nclock",
#					"Pass to a free\nplayer"]

var time = null
var score = null
var cards = null

var numero_preguntas_nivel = 10
var turno
var user_ans

# Cargamos nuestro fichero de preguntas en una variable.
onready var preguntas_del_nivel:Dictionary  = Game.load_data(Game.questions)

var respuesta_correcta

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
	turno = 0

	randomize() # Actualiza la semilla para generar aleatorios.
	indices.shuffle() # Barajea aleatoriamente el array de indices.
   
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
#	_aumentar_score()
	user_ans = 0
	$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true
	_prompt_if_pressed()
	pass # Replace with function body.

func _on_Option_2_pressed():
	user_ans = 1
	$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true
#	GlobalVar._aumentar_tarjeta()
	_prompt_if_pressed()
	pass # Replace with function body.

func _on_Option_3_pressed():
	user_ans = 2
	$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true
	_prompt_if_pressed()
	pass # Replace with function body.
	
func _on_Option_4_pressed():
	user_ans = 3
	$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true
	_prompt_if_pressed()
	pass # Replace with function body.

func _prompt_if_pressed():
	if(user_ans==respuesta_correcta):
		_aumentar_score()
		print('it works')
		get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta!."
		#get_tree().reload_current_scene()
	else:
		GlobalVar._aumentar_tarjeta()
		get_node("Answer_Window/proceed_label").text="¡Respuesta Incorrecta!."
		print('doesnt work')
	 
	# comprobamos si es el final del juego
	if turno < numero_preguntas_nivel-1:
		turno += 1 # pasamos a otra pregunta
		get_tree().change_scene("")
		carga_pregunta()
	else:
		print('F')

func _on_Btn_Back_pressed():
	$Background.visible = false
	$Players.visible = true
	$Question.visible = false
	$Btn_Back.visible = false
	$Btn_Question.visible = true
	$Footer.visible = true
	$Answer_Window.visible = false

func carga_pregunta():
	# Asigna la pregunta almacenada en el índice correspondiente al turno en juego
	var pregunta_actual = elige_pregunta(indices[turno])
	

	# creamos botones aleatorios
#	var botones_random = $Question/Options.get_children()
#	randomize() # actualizamos la semilla
#	botones_random.shuffle() # barajamos los botones

	
	# actualizamos los nodos con los datos asignados
#	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"] # La pregunta   
#	botones_random[0].get_node("lbl").text = pregunta_actual["respA"]
#	botones_random[1].get_node("lbl").text = pregunta_actual["respB"]
#	botones_random[2].get_node("lbl").text = pregunta_actual["respC"]
#	botones_random[3].get_node("lbl").text = pregunta_actual["respD"]
	
	
	$Question/Question_Window/lbl_question.text = pregunta_actual["pregunta"]
	$Question/Options/Option_1/lbl.text = pregunta_actual["respA"]
	$Question/Options/Option_2/lbl.text = pregunta_actual["respB"]
	$Question/Options/Option_3/lbl.text = pregunta_actual["respC"]
	$Question/Options/Option_4/lbl.text = pregunta_actual["respD"]
	
	respuesta_correcta = pregunta_actual["buena"]

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

func _on_Btn_Next_pressed():
	pass # Replace with function body.
 
func salir():
	get_tree().change_scene("res://src/scenes/Main.tscn")


	
