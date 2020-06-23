extends Node2D

var time = null
var cards = null
var user_ans=-1
var number_questions = 5

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
			#entry["correct"] = i == _correct_index
			entry["correct"] = _correct_index[i]
			_shuffled.append(entry)
		randomize()
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
	if total_questions.empty():
		salir()
	inicializar()
	#_cambiar_saque()
	time = "0:" + str(int($Timer.time_left))
	cards = "%02d" % GlobalVar.yellow_card
	_assign_text()
	
func inicializar():
	var number_questions_available = count_indexes()
	if number_questions_available < number_questions:
		salir()
	turn = 0
	load_question()

func resetting_values():
	$Timer.stop()
	GlobalVar.yellow_card = 0
	GlobalVar.score = 0

func _process(_delta):
	if(GlobalVar.yellow_card >= 2):
		resetting_values()
		$Disqualification.visible = true
		$Answer_Window/Btn_Next.visible = false
	
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

func _aumentar_score(i):
	#_cambiar_saque()
	GlobalVar._aumentar_score_global(i)

func _assign_text():
	$Footer/Time.text = time
	$Footer/Card.text = cards
	
	$Question/Time.text = time
	$Question/Card.text = cards

func _on_Timer_timeout():
	get_tree().change_scene("res://src/scenes/Main.tscn")

func _on_Btn_home_pressed():
	get_tree().change_scene("res://src/scenes/Main.tscn")
	pass

func _on_Option_1_pressed():
	user_ans = 0
	_prompt_and_check()

func _on_Option_2_pressed():
	user_ans = 1
	_prompt_and_check()

func _on_Option_3_pressed():
	user_ans = 2
	_prompt_and_check()

func _on_Option_4_pressed():
	user_ans = 3
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
	$Question.visible = false
	$Btn_Back.visible = true
	$Answer_Window/translation.set_text(_question.get_shuffled_translation(user_ans))
	
	if(_question.is_answer_correct(user_ans)==0):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		
		_aumentar_score(10)
		get_node("Answer_Window/proceed_label").text="¡Buena respuesta!"
	elif(_question.is_answer_correct(user_ans)==1):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		_aumentar_score(20)
		get_node("Answer_Window/proceed_label").text="¡Excelente respuesta!"
	elif(_question.is_answer_correct(user_ans)==3):
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		_aumentar_score(10)
		get_node("Answer_Window/proceed_label").text="¡Respuesta Correcta!"
		#get_tree().reload_current_scene()
	else:
		$Before_Answer.visible = false
		$Answer_Window.visible = true
		$Btn_Back.visible = false
		GlobalVar._aumentar_tarjeta()
		get_node("Answer_Window/proceed_label").text="¡Respuesta Incorrecta!"


func load_question():

	#var current_question = randi() % questions.size()
	randomize()
	indexes.shuffle()
	#print(indexes)
	var current_question = choose_question(indexes[turn])
	#print(indexes[turn])
	#print(int(indexes[turn])-1) # this is the way it works
	_question = Question.new(current_question)
	#print(current_question)
	$Question/Label.text = current_question["question"] 
	$Question/Options/Option_1/lbl.set_text(_question.get_shuffled_answer(0))
	$Question/Options/Option_2/lbl.set_text(_question.get_shuffled_answer(1))
	$Question/Options/Option_3/lbl.set_text(_question.get_shuffled_answer(2))
	$Question/Options/Option_4/lbl.set_text(_question.get_shuffled_answer(3))


	var backgrounds = $Situations.get_children()
	for node in backgrounds:
		node.hide() # start by hiding all BGs
	$Situations.get_child(int(indexes[turn])-1).show() # unhide the one we want
	_question.print_me()

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

func _on_Btn_Next_pressed():
	if turn < number_questions-1:
		turn += 1 
		#get_tree().change_scene("")
		#get_tree().reload_current_scene()
		$Footer.visible = true
		$Timer.start()
		load_question()
		$Btn_Question.visible = true
		$Answer_Window.visible = false
	else:
		$Final_Score.visible = true
		$Answer_Window.visible = false
		$Final_Score/final_score.text = str(GlobalVar.score)
		print('Game Over')
	pass # Replace with function body.


func salir():
	resetting_values()
	get_tree().change_scene("res://src/scenes/Main.tscn")


func _on_Btn_Restart_pressed():
	resetting_values()
	get_tree().change_scene("res://src/scenes/Throw-in.tscn")
	pass # Replace with function body.

func _on_Btn_Exit_pressed():
	salir()
	pass # Replace with function body.


func _on_Btn_Ok_pressed():
	GlobalVar.test = true
	salir()
	pass # Replace with function body.

func _on_Btn_Back_pressed():
	#$Players.visible = true
	$Situations.get_child(int(indexes[turn])-1).show()
	$Background.visible = false
	$Question.visible = false
	$Btn_Back.visible = false

	$Btn_Question.visible = true
	$Footer.visible = true
	$Answer_Window.visible = false
		
func _on_Btn_Question_pressed():
	#$Players.visible = false
	$Situations.get_child(int(indexes[turn])-1).hide()
	$Background.visible = true
	$Question.visible = true
	$Btn_Back.visible = true
			
	$Btn_Question.visible = false
	$Footer.visible = false
	$Before_Answer.visible = false
			

	"""
func _on_background_changed(flip = false):
	$Background.visible = false if not flip else true
	$Question.visible = false if not flip else true
	$Btn_Back.visible = false if not flip else true
	#$Btn_Question.visible = true
	#$Footer.visible = true
	#$Answer_Window.visible = false
	pass # Replace with function body.
	"""
