extends Node

var points = 0

func _ready():
	add_points()

func get_current_points():
	return points

func add_points(amount = 1):
	points += amount

func remove_point():
	points -= 1