extends Node2D


#var tipos_saques = ["Pass the ball to\nany teanmate", 
#					"Pass the ball to\nthe goalkeeper", 
#					"Run up the\nclock",
#					"Pass to a free\nplayer"]
var time = null
var cards = null
var user_ans=-1
var number_questions = 2
var correct_answer

var turn
onready var total_questions:Dictionary  = Game.load_data(Game.questions)
var indexes:Array = []
var _question

class Question:
	var _answers = []
	var _translations = []
	#var _correct_index = -1
	var _correct_index = []
	var _shuffled = []
	var correct2 = ["a", "b"]
	var correct1 = [0,1]
	var _new_array = []

	func _init(json_stuff):
		_answers = json_stuff["answers"]
		_translations = json_stuff["translations"]
		_correct_index = json_stuff["correct"]
		matching()
		_shuffle()

	func _shuffle():
		_shuffled.clear()
		for i in range(_answers.size()):
			var entry = {}
			entry["answer"] = _answers[i]
			entry["translation"] = _translations[i]
			#entry["correct"] = i == _correct_index
			#_new_array = Array(_answers)
			#match correct.find(_answers[i]):
			entry["correct"] = _correct_index[i]
			_shuffled.append(entry)
		_shuffled.shuffle()

	func matching():
		#for i in correct2:
			#match correct1.find(correct2.find(i)):
		for i in _answers:
			match _correct_index.find(_answers.find(i)):
		#for i in range(correct2.size()):
			#match correct1.find(i):
		#for i in range(_answers.size()):
			#match _correct_index.find(i):
				-1:
					print("Wrong")
				0:
					print("Best")
				1:
					print("Good")
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
	if total_questions.empty():
		salir()
	inicializar()
	#_cambiar_saque()
	time = "0:" + str(int($Timer.time_left))
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()
	
func inicializar():
	#_question._shuffle()
	var number_questions_available = count_indexes()

	if number_questions_available < number_questions:
		salir()
		
	#randomize() # actualiza la semilla para generar aleatorios
	#indexes.shuffle()
	turn = 0
	
	for i in range(indexes.size()):
		var k = i+1
		#print(indexes[i])
		if(indexes[i]):
			print(indexes[i])
			$Situations/Players2.visible = true
			print('players2')
			#print(indexes[i]==str(k))
		elif(indexes[i]==str(k)):
			$Situations/Players.visible = true
			print('players1')
		#elif(indexes[i]==str(k)):
		#	#$Situations/Players2.visible = true
		#	print('players3')
		#elif(indexes[i]==str(k)):
		#	#$Situations/Players2.visible = true
		#	print('players4')
		#elif(indexes[i]==str(k)):
		#	#$Situations/Players2.visible = true
		#	print('players5')
		else:
			print('hopefully this works')
			
	#for i in range(count_indexes()):
	#	print(number_questions_available)
	load_question()

func _process(delta):
	if(GlobalVar.yellow_card >= 2):
		$Timer.stop()
		GlobalVar.yellow_card = 0
		GlobalVar.score = 0
		get_tree().change_scene("res://src/scenes/Main.tscn")
	
	time = "00:%02d" % int($Timer.time_left)
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()

	"""
func _cambiar_saque():
	randomize()
	$Question/Option_1/lbl.text = tipos_saques[0]
	$Question/Option_2/lbl.text = tipos_saques[1]
	$Question/Option_3/lbl.text = tipos_saques[2]
	$Question/Option_4/lbl.text = tipos_saques[3]
	#$Text.text = tipos_saques[randi() % tipos_saques.size()]
	"""

func _aumentar_score():
	#_cambiar_saque()
	GlobalVar._aumentar_score_global(10)


func _assign_text():
	$Footer/Time.text = time
	$Footer/Card.text = cards
	
	$Question/Time.text = time
	$Question/Card.text = cards


func _on_Timer_timeout():
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_Btn_Question_pressed():
	#$Players.visible = false
	$Situations/Players2.visible = false
	#$Situations/Players.visible = false
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
	user_ans = 0
	"""
	if(_question.is_answer_correct(0)):
		print('working')
	else:
		print('nope 1')
		"""	
	#user_ans = $Question/Options.get_child(0).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.

func _on_Option_2_pressed():
	user_ans = 1
	"""
	if(_question.is_answer_correct(1)):
		print('working maybe 2')
		# do correct answer stuff here
	else:
		print('nope 2')
		"""
	#user_ans = $Question/Options.get_child(1).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.

func _on_Option_3_pressed():
	user_ans = 2
	"""
	if(_question.is_answer_correct(2)):
		print('working maybe 3')
		# do correct answer stuff here
	else:
		print('nope3')
		"""
	#user_ans = $Question/Options.get_child(2).get_meta("answer")
	_prompt_and_check()
	pass # Replace with function body.
	
func _on_Option_4_pressed():
	user_ans = 3
	"""
	if(_question.is_answer_correct(3)):
		print('working maybe 4')
		# do correct answer stuff here
	else:
		print('nope 4')
		"""
	#user_ans = $Question/Options.get_child(3).get_meta("answer")
	_prompt_and_check()
	
func _prompt_and_check():
	$Before_Answer.visible = true
	$Btn_Back.visible = false
	$Before_Answer/translation.set_text(_question.get_shuffled_translation(user_ans))


func _on_Btn_No_pressed():
	$Before_Answer.visible = false
	$Answer_Window.visible = false
	$Question.visible = true
	$Btn_Back.visible = true

func _on_Btn_Yes_pressed():
	$Before_Answer.visible = false
	#$Answer_Window.visible = true
	$Question.visible = false
	$Btn_Back.visible = true
	$Answer_Window/translation.set_text(_question.get_shuffled_translation(user_ans))
	
	if(_question.is_answer_correct(user_ans)==0):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		
		_aumentar_score()
		print('it works Best')
		get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta! Best"
	elif(_question.is_answer_correct(user_ans)==1):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		_aumentar_score()
		print('it works Good')
		get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta! Good"
		#get_tree().reload_current_scene()
	else:
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		#GlobalVar._aumentar_tarjeta()
		get_node("Answer_Window/proceed_label").text="¡Respuesta Incorrecta!"
		print('doesnt work')
		"""		
func scene_next():
	#var situations = $Situations.get_children()
	for i in range(turn):
		#$Situations/Players.visible = true
		"""

func load_question():
	var current_question = choose_question(indexes[turn])
	#var question = Question.new(current_question)
	_question = Question.new(current_question)

	$Question/Label.text = current_question["pregunta"] 
	$Question/Options/Option_1/lbl.set_text(_question.get_shuffled_answer(0))
	$Question/Options/Option_2/lbl.set_text(_question.get_shuffled_answer(1))
	$Question/Options/Option_3/lbl.set_text(_question.get_shuffled_answer(2))
	$Question/Options/Option_4/lbl.set_text(_question.get_shuffled_answer(3))

	
#	var idk = $Situations.get_children()

	#if(idk[0].get_node("Label").get_text == 0):
	#	$Situations/Players2.visible = true
	
	#$Before_Answer/translation.set_text(_question.get_shuffled_translation(user_ans))
	#$Before_Answer/translation.set_text(_question.get_shuffled_translation(1))
	#$Before_Answer/translation.set_text(_question.get_shuffled_translation(2))
	#$Before_Answer/translation.set_text(_question.get_shuffled_translation(3))

	#button1.set_text(question.get_shuffled_answer(0))
	#button2.set_text(question.get_shuffled_answer(1))
	_question.print_me()
	
	"""
	# creamos botones aleatorios
	var botones_random = $Question/Options.get_children()
	randomize() # actualizamos la semilla
	botones_random.shuffle() # barajamos los botones

	
	# actualizamos los nodos con los datos asignados
	$Question/Label.text = pregunta_actual["pregunta"] # La pregunta   
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
	#$Before_Answer/translation.text = pregunta_actual["translation"]
	#$Answer_Window/translation.text = pregunta_actual["translation"]

func choose_question(question_id:String):
	# Check if the index exist
	if total_questions.has(question_id):
		return total_questions[question_id] # if the index exists, returns the dictionary.
	else:
		print('error')
		return {} # if not, returns empty.
			 
func count_indexes():
	# We load in the array the indexes of all the numbers of the questions.
	indexes = total_questions.keys()
	return indexes.size() 
		 
func _on_Btn_Back_pressed():
	$Background.visible = false
	#$Players.visible = true
	$Situations/Players2.visible = true
	$Question.visible = false
	$Btn_Back.visible = false
	$Btn_Question.visible = true
	$Footer.visible = true
	$Answer_Window.visible = false


func _on_Btn_Next_pressed():
	if turn < number_questions-1:
		turn += 1 
		$Question.visible = true
		$Answer_Window.visible = false
		$Btn_Back.visible = true
		#get_tree().change_scene("")
		load_question()
	else:
		#transicion.ir_a_escena("res://escenas/premios.tscn")
		$Final_Score.visible = true
		$Answer_Window.visible = false
		$Final_Score/final_score.text = str(GlobalVar.score)
		print('Game Over')
	pass # Replace with function body.

func salir():
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_Btn_Restart_pressed():
	get_tree().change_scene("res://src/scenes/Throw-in.tscn")
	pass # Replace with function body.
	"""
func test():
	var idk = $Situations.get_children()

	idk[0].get_node("Label").text = pregunta_actual["respD"]
	"""

func _on_Btn_Exit_pressed():
	salir()
	pass # Replace with function body.
