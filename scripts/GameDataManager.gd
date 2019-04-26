extends Node

signal points_changed()

var save_data = {}
var default_save_data = {
	"level_data": {
		1: {
			"unlocked": true,
			"highscore": 0,
			"stars_unlocked": 0
		}
	},
	"points": 1,
}
onready var path = "res://save.dat"

func _ready():
	save_data = load_data()

func get_current_points():
	return save_data["points"]

func add_points(amount = 1):
	save_data["points"] += min(10, amount)
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