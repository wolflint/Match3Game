extends Node

var levels_info = {}
var default_level_info = {
	1: {
		"unlocked": true,
		"highscore": 0,
		"stars_unlocked": 0
	}
}
onready var path = "user://save.dat"

func _ready():
	levels_info = load_data()


func save_data():
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err != OK:
		print("Something went wrong during save: " + self.filename)
		return
	file.store_var(levels_info)
	file.close()

func load_data():
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		print("Something went wrong during load: " + self.filename)
		return default_level_info
	var read = file.get_var()
	return read