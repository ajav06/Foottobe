extends Node

var bestscore = 0 setget set_bestscore
var yellowcard = 0 setget set_yellowcard
var redcard = 0 setget set_redcard
var timeRedCard = 0 setget set_timeRCard
var arraydata = [0,0,0,0]
const filepath = "user://datauser.data"

func _ready():
	load_bestscore()
	pass # Replace with function body.

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
