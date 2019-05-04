extends Node

signal points_changed()

onready var path = "user://save.dat"
var save_data = {}
var default_save_data = {
	"level_data": {
		1: {
			"unlocked": true,
			"highscore": 0,
			"star_unlocked": false
		},
		2: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		3: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		4: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		5: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		6: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		7: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		8: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		9: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		10: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		11: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		12: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		13: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		14: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		15: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},
		16: {
			"unlocked": false,
			"highscore": 0,
			"star_unlocked": false
		},

	},
	"points": 1,
}

func _ready():
	save_data = load_data()

func get_current_points():
	if save_data.has("points"):
		return save_data["points"]
	else:
		load_data()

func add_points(amount = 1):
	amount = int(min(10, save_data["points"] + amount))
	save_data["points"] = amount
	emit_signal("points_changed")

func remove_point():
	save_data["points"] -= 1
	emit_signal("points_changed")


func save_data():
	var file = File.new()
	var err = file.open(path, File.WRITE)
	if err != OK:
		print("Something went wrong during save: " + self.filename)
		return
	file.store_var(save_data)
	file.close()

func load_data():
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		print("Something went wrong during load: " + self.filename)
		return default_save_data
	var read = file.get_var()
	return read