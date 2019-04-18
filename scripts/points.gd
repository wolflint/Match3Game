var points = 0

func _ready():
	add_point()

func get_current_points():
	return points

func add_point():
	points += 1

func remove_point():
	points -= 1