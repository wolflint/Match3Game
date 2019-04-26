extends Node2D

var ice_pieces = []
var width = 8
var height = 10
var ice = preload("res://scenes/Ice.tscn")

# goal values
signal break_ice
export (String) var goal_string


func _ready():
	pass


func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null);
	return array


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Grid_make_ice(board_position, offset, x_start, y_start):
	if ice_pieces.size() == 0:
		ice_pieces = make_2d_array()
	var current = ice.instance()
	add_child(current)
	current.position = Vector2(board_position.x * offset + x_start, -board_position.y * offset + y_start)
#	current.position = Vector2(board_position.x, board_position.y)
	ice_pieces[board_position.x][board_position.y] = current


func _on_Grid_damage_ice(board_position):
	if ice_pieces.size() != 0 and ice_pieces.size() != null:
		if ice_pieces[board_position.x][board_position.y]:
			ice_pieces[board_position.x][board_position.y].take_damage(1)
			if ice_pieces[board_position.x][board_position.y].health <= 0:
				ice_pieces[board_position.x][board_position.y].queue_free()
				ice_pieces[board_position.x][board_position.y] = null
				emit_signal("break_ice", goal_string)