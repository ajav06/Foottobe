extends Node

var bestscore = 0 setget set_bestscore
var yellowcard = 0 setget set_yellowcard
var redcard = 0 setget set_redcard
var timeRedCard = 0 setget set_timeRCard
var arraydata = [0,0,0,0]
const filepath = "user://datauser.data"

const DATA_PATH = "res://src/data/"
var questions = "questions"

func _ready():
	#print(load_data(questions))
	load_bestscore()
	pass # Replace with function body.


func load_data(file_name) -> Dictionary:
	# Comprobamos que llega un nombre.
	if file_name == null: return {}
	
	# Creamos una variable para manejar un fichero.
	var file = File.new()
	
	# Completamos la ruta para nuestro fichero.
	var file_path = DATA_PATH + file_name + ".json"
	
	# Compruebo si el archivo existe, si no, devuelvo un diccionario vacío.
	if !file.file_exists(file_path): return {}
	
	# Abrimos el archivo para su lectura.
	file.open(file_path, File.READ)
	
	# Asignamos el contenido a una variable tipo Dictionary.
	var data:Dictionary = {}
	data = parse_json(file.get_as_text())

	file.close()
	
	return data

func load_bestscore():
	var file = File.new()
	if not file.file_exists(filepath): return
	file.open(filepath, File.READ)
	arraydata = file.get_var()
	bestscore = arraydata[0]
	yellowcard = arraydata[1]
	redcard = arraydata[2]
	timeRedCard = arraydata[3]
	file.close()
	pass
	
func save_data():
	var file = File.new()
	file.open(filepath, File.WRITE)
	file.store_var(arraydata)
	file.close()
	pass
	
func set_bestscore(new_value):
	bestscore = new_value
	arraydata[0] = bestscore
	save_data()
	pass

func set_yellowcard(new_value):
	yellowcard += new_value
	arraydata[1] = yellowcard
	print(arraydata)
	save_data()
	pass
	
func set_redcard(new_value):
	redcard += new_value
	arraydata[2] = redcard
	save_data()
	pass

func set_timeRCard(new_value):
	timeRedCard = new_value
	arraydata[3] = timeRedCard
	save_data()
	pass
