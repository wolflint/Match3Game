extends Node2D

# State machine
enum {wait, move, game_over, game_win}
var state

# Grid Variables
export (int) var width
export (int) var height
export (int) var x_start
export (int) var y_start
export (int) var offset
export (int) var y_offset
export (int, 2, 8) var max_piece_types

# Obstacle Variables
export (PoolVector2Array) var empty_spaces
export (PoolVector2Array) var ice_spaces
export (PoolVector2Array) var lock_spaces
export (PoolVector2Array) var concrete_spaces
export (PoolVector2Array) var slime_spaces
var damaged_slime = false

# Obstace Signals
signal make_ice
signal damage_ice
signal make_lock
signal damage_lock
signal make_concrete
signal damage_concrete
signal make_slime
signal damage_slime

# Preset spaces
export (PoolVector3Array) var preset_spaces

# The piece array
var available_pieces = [
preload("res://scenes/pieces/RedPiece.tscn"),
preload("res://scenes/pieces/LightGreenPiece.tscn"),
preload("res://scenes/pieces/BluePiece.tscn"),
preload("res://scenes/pieces/YellowPiece.tscn"),
preload("res://scenes/pieces/GreenPiece.tscn"),
preload("res://scenes/pieces/OrangePiece.tscn"),
preload("res://scenes/pieces/PinkPiece.tscn"),
preload("res://scenes/pieces/PurplePiece.tscn")
]
var possible_pieces = []

# The current pieces in the scene
var all_pieces = []
var clone_array = []
var current_matches = []

# Swap back variables
var piece_one = null
var piece_two = null
var last_place = Vector2(0,0)
var last_direction = Vector2(0,0)
var move_checked = false

# Touch Variables
var first_touch = Vector2(0, 0)
var final_touch = Vector2(0, 0)
var controlling = false

# Scoring variables
signal update_score
signal setup_max_score
signal maximum_streak_reached
export(int) var max_score
export (int) var piece_value
var streak = 1

# Counter variables
signal update_counter
export(int) var current_counter_value
export(bool) var is_moves

# Goal check
signal check_goal

# Game win variables
var goals_met = false
signal open_game_win_panel



# bomb effect variables
var color_bomb_used = false
var cleared_board = false

# Sinkers
export (PackedScene) var sinker_piece
export (bool) var sinkers_in_scene
export (int) var max_sinkers
var current_sinkers = 0

# Effects
var particle_effect = preload("res://scenes/ParticleEffect.tscn")
#var explosion_animation = preload("res://scenes/ExplosionAnimation.tscn")

# Hint system stuff
export(PackedScene) var hint_effect
var hint = null
var hint_color = ""

# Game over
signal game_over

func _ready():
	for i in range(0, max_piece_types):
		possible_pieces.append(available_pieces[i])
	state = move
	all_pieces = make_2d_array()
	clone_array = make_2d_array()
	spawn_preset_pieces()
	if sinkers_in_scene:
		spawn_sinkers(max_sinkers)
	spawn_pieces()
	spawn_ice()
	spawn_locks()
	spawn_concrete()
	spawn_slime()
	if is_deadlocked():
		shuffle_board()
	emit_signal("update_counter", current_counter_value)
	emit_signal("setup_max_score", max_score)
	if !is_moves:
		$Timer.start()

func restricted_fill(place):
	# Check empty pieces
	if is_in_array(empty_spaces, place):
		return true
	# Check for concrete
	if is_in_array(concrete_spaces, place):
		return true
	if is_in_array(slime_spaces, place):
		return true
	return false

func restricted_move(place):
	# Check lock pieces
	if is_in_array(lock_spaces, place):
		return true
#	elif is_in_array(ice_spaces, place):
#		return true
	return false

func is_ice_block(place):
	if is_in_array(ice_spaces, place):
		return true
	return false

func is_in_array(array, item):
	if array != null:
		for i in array.size():
			if array[i] == item:
				return true
		return false

func remove_from_array(new_array, item):
	for i in range(new_array.size() -1, -1, -1):
		if new_array[i] == item:
			new_array.remove(i)
			return new_array

func make_2d_array():
	var array = []
	for i in width:
		array.append([])
		for j in height:
			array[i].append(null);
	return array

func spawn_pieces():
	randomize()
	for i in width:
		for j in height:
			if !restricted_fill(Vector2(i, j)) and all_pieces[i][j] == null:
				# Choose a random number and store it
				var rand = floor(rand_range(0, possible_pieces.size()))
				var piece = possible_pieces[rand].instance()
				var loops = 0
				while(match_at(i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, possible_pieces.size()))
					loops += 1;
					piece = possible_pieces[rand].instance();
				# Instance that piece from the array
				add_child(piece);
				piece.position = grid_to_pixel(i, j)
				all_pieces[i][j] = piece;
	$HintTimer.start()

func is_piece_sinker(col, row):
	if all_pieces[col][row] != null:
		if all_pieces[col][row].color == "None":
			return true
	return false

func match_at(i, j, color):
	if i > 1:
		if all_pieces[i-1][j] != null && all_pieces[i-2][j] != null:
			if all_pieces[i-1][j].color == color && all_pieces[i-2][j].color == color:
				return true
	if j > 1:
		if all_pieces[i][j-1] != null && all_pieces[i][j-2] != null:
			if all_pieces[i][j-1].color == color && all_pieces[i][j-2].color == color:
				return true

func check_match_hlength(col, row, color):
	var match_length = 0
	var position_x = col

	while position_x > 0:
		if all_pieces[position_x][row].color == color:
			position_x -= 1
			match_length += 1
		else:
			position_x = col
			break

	while position_x < width:
		if all_pieces[position_x][row].color == color:
			position_x += 1
			match_length += 1
		else:
			return match_length

func check_match_vlength(col, row, color):
	var match_length = 0
	var position_y = row

	while position_y > 0:
		if all_pieces[col][position_y].color == color:
			position_y -= 1
			match_length += 1
		else:
			position_y = col
			break

	while position_y < width:
		if all_pieces[col][position_y].color == color:
			position_y += 1
			match_length += 1
		else:
			return match_length

func grid_to_pixel(column, row):
	var new_x = x_start + offset * column;
	var new_y = y_start + -offset * row;
	return Vector2(new_x, new_y)

func pixel_to_grid(pixel_x, pixel_y):
	var new_x = round((pixel_x - x_start) / offset)
	var new_y = round((pixel_y - y_start) / -offset)
	return Vector2(new_x, new_y)

func is_in_grid(grid_position):
	if grid_position.x >= 0 && grid_position.x < width:
		if grid_position.y >= 0 && grid_position.y < height:
			return true
	return false

func touch_input():
	if Input.is_action_just_pressed("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)):
			first_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			controlling = true
			if hint:
				hint.queue_free()
				hint = null
	if Input.is_action_just_released("ui_touch"):
		if is_in_grid(pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)) && controlling:
			controlling = false
			final_touch = pixel_to_grid(get_global_mouse_position().x, get_global_mouse_position().y)
			touch_difference(first_touch, final_touch)

func swap_pieces(column, row, direction):
	var first_piece = all_pieces[column][row]
	var other_piece = all_pieces[column + direction.x][row + direction.y]
	if !is_piece_sinker(column, row) and !is_piece_sinker(column + direction.x, row + direction.y):
		if first_piece != null  && other_piece != null:
			if !restricted_move(Vector2(column, row)) and !restricted_move(Vector2(column, row) + direction):
				if is_color_bomb(first_piece) and is_color_bomb(other_piece):
					# TODO: I don't like this fix. Need to change this
					if is_piece_sinker(column, row) or is_piece_sinker(column + direction.x, row + direction.y):
						swap_back()
					clear_board()
					match_and_dim(first_piece)
					add_to_array(Vector2(column, row))
					match_and_dim(other_piece)
					add_to_array(Vector2(column + direction.x, row + direction.y))
				elif is_color_bomb(first_piece) or is_color_bomb(other_piece):
					if is_color_bomb(first_piece):
						match_color(other_piece.color)
						match_and_dim(first_piece)
						add_to_array(Vector2(column, row))
					elif is_color_bomb(other_piece):
						match_color(first_piece.color)
						match_and_dim(other_piece)
						add_to_array(Vector2(column + direction.x, row + direction.y))
				store_info(first_piece, other_piece, Vector2(column, row), direction)
				state = wait
				all_pieces[column][row] = other_piece
				all_pieces[column + direction.x][row + direction.y] = first_piece
				first_piece.move(grid_to_pixel(column + direction.x, row + direction.y))
				other_piece.move(grid_to_pixel(column, row))
				if !move_checked:
					find_matches()

func is_color_bomb(piece):
	if piece.color == "Color":
		return true
	return false

func spawn_ice():
	if ice_spaces != null:
		for i in ice_spaces.size():
			emit_signal("make_ice", ice_spaces[i])

func spawn_locks():
	if lock_spaces != null:
		for i in lock_spaces.size():
			emit_signal("make_lock", lock_spaces[i])

func spawn_concrete():
	if concrete_spaces != null:
		for i in concrete_spaces.size():
			emit_signal("make_concrete", concrete_spaces[i])

func spawn_slime():
	if slime_spaces != null:
		for i in slime_spaces.size():
			emit_signal("make_slime", slime_spaces[i])

func spawn_sinkers(number_to_spawn):
	for i in number_to_spawn:
		var column = floor(rand_range(0, width))
		while all_pieces[column][height-1] != null or restricted_fill(Vector2(column, height-1)):
			column = floor(rand_range(0, width))
		var current = sinker_piece.instance()
		add_child(current)
		current.position = grid_to_pixel(column, height - 1)
		all_pieces[column][height - 1] = current
		current_sinkers += 1

func spawn_preset_pieces():
	if preset_spaces != null:
		if preset_spaces.size() > 0:
			for i in preset_spaces.size():
				var piece = possible_pieces[preset_spaces[i].z].instance()
				add_child(piece)
				var col = preset_spaces[i].x
				var row = preset_spaces[i].y
				piece.position = grid_to_pixel(col, row)
				all_pieces[col][row] = piece

func store_info(first_piece, other_piece, place, direction):
	piece_one = first_piece
	piece_two = other_piece
	last_place = place
	last_direction = direction

func swap_back():
	# Move swapped pieces back if no match
	if piece_one != null && piece_two != null:
		swap_pieces(last_place.x, last_place.y, last_direction)
		state = move
		move_checked = false
		$HintTimer.start()

func touch_difference(grid_1, grid_2):
	var difference = grid_2 - grid_1
	if abs(difference.x) > abs(difference.y):
		if difference.x > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(1, 0))
		elif difference.x < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(-1, 0))
	elif abs(difference.y) > abs(difference.x):
		if difference.y > 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, 1))
		elif difference.y < 0:
			swap_pieces(grid_1.x, grid_1.y, Vector2(0, -1))

func _process(delta):
	if state == move:
		touch_input()

func find_matches(query = false, array = all_pieces):
	for i in width:
		for j in height:
			if array[i][j] != null and !is_piece_sinker(i, j):
				var current_color = array[i][j].color
				if i > 0 && i < width - 1:
					if array[i - 1][j] != null and array[i + 1][j] != null:
						if array[i - 1][j].color == current_color && array[i + 1][j].color == current_color:
							if query:
								hint_color = current_color
								return true
							match_and_dim(array[i - 1][j])
							match_and_dim(array[i][j])
							match_and_dim(array[i + 1][j])
							add_to_array(Vector2(i, j))
							add_to_array(Vector2(i+1, j))
							add_to_array(Vector2(i-1,j))
				if j > 0 && j < height - 1:
					if array[i][j - 1] and array[i][j + 1]:
						if array[i][j - 1].color == current_color && array[i][j + 1].color == current_color:
							if query:
								hint_color = current_color
								return true
							match_and_dim(array[i][j - 1])
							match_and_dim(array[i][j])
							match_and_dim(array[i][j + 1])
							add_to_array(Vector2(i, j))
							add_to_array(Vector2(i, j+1))
							add_to_array(Vector2(i, j-1))
	if query:
		return false
	get_bombed_pieces()
	get_parent().get_node("DestroyTimer").start()

func get_bombed_pieces():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if all_pieces[i][j].matched:
					if all_pieces[i][j].is_column_bomb:
						all_pieces[i][j].is_column_bomb = false
						match_all_in_column(i, j)
					elif all_pieces[i][j].is_row_bomb:
						all_pieces[i][j].is_row_bomb = false
						match_all_in_row(i, j)
					elif all_pieces[i][j].is_adjacent_bomb:
						all_pieces[i][j].is_adjacent_bomb = false
						find_adjacent_pieces(i, j)

func is_piece_null(column, row, array = all_pieces):
	if array[column][row] == null:
		return true
	return false

func add_to_array(value, array_to_add = current_matches):
	if !array_to_add.has(value):
		array_to_add.append(value)

func find_bombs():
	if !color_bomb_used:
	# Iterate ove the current_matches array
		for i in current_matches.size():
			# Store some values for this match
			var current_column = current_matches[i].x
			var current_row = current_matches[i].y
			var current_color = all_pieces[current_column][current_row].color
			var col_matched = 0
			var row_matched = 0
			# Iterate over the current matches to check for column, row and color
			for j in current_matches.size():
				var this_column = current_matches[j].x
				var this_row = current_matches[j].y
				var this_color = all_pieces[this_column][this_row].color
				if this_column == current_column and current_color == this_color:
					col_matched += 1
				if this_row == current_row and this_color == current_color:
					row_matched += 1
			# 0 is an adj bomb, 1 is a column bomb, and 2 is a row bomb
			# 3 is a color bomb
			if col_matched == 5 or row_matched == 5:
				make_bomb(3, current_color)
				continue
			elif col_matched == 3 and row_matched ==3:
				make_bomb(0, current_color)
				continue
			elif col_matched == 4:
				make_bomb(1, current_color)
				continue
			elif row_matched == 4:
				make_bomb(2, current_color)
				continue

func make_bomb(bomb_type, color):
	# Iterate over current_matches
	for i in current_matches.size():
		# Cache a few variables
		var current_column = current_matches[i].x
		var current_row = current_matches[i].y
		if !cleared_board:
			if all_pieces[current_column][current_row] == piece_one and piece_one.color == color:
				# Make piece_one a bomb
				damage_special(current_column, current_row)
				emit_signal("check_goal", piece_one.color)
				piece_one.matched = false
				change_bomb(bomb_type, piece_one)
			if all_pieces[current_column][current_row] == piece_two and piece_two.color == color:
				# Make piece_two a bomb
				damage_special(current_column, current_row)
				emit_signal("check_goal", piece_two.color)
				piece_two.matched = false
				change_bomb(bomb_type, piece_two)

func change_bomb(bomb_type, piece):
	if bomb_type == 3:
		piece.make_colour_bomb()
	elif bomb_type == 0:
		piece.make_adjacent_bomb()
	elif bomb_type == 1:
		piece.make_row_bomb()
	elif bomb_type == 2:
		piece.make_column_bomb()

func match_and_dim(item):
	item.matched = true
	item.dim()

func destroy_matched(was_matched = false):
	# var was_matched = false
	find_bombs()
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if all_pieces[i][j].matched:
					var piece_color = all_pieces[i][j].color
					damage_special(i, j)
					emit_signal("update_score", piece_value * streak)
					emit_signal("check_goal", piece_color)
					was_matched = true
					all_pieces[i][j].queue_free()
					all_pieces[i][j] = null
					make_particle_effect(i, j, piece_color)
#					make_effect(explosion_animation, i, j)
	#find_bombs()
	move_checked = true
	if was_matched:
		destroy_hint()
		get_parent().get_node("CollapseTimer").start()
	else:
		swap_back()
	current_matches.clear()

func make_effect(effect, column, row):
	var current = effect.instance()
	current.position = grid_to_pixel(column, row)
	add_child(current)

func make_particle_effect(column, row, color):
	var current = particle_effect.instance()
	current.change_color(color)
	current.position = grid_to_pixel(column, row)
	add_child(current)

func check_concrete(column, row):
	# Check right
	if column < width - 1:
		emit_signal("damage_concrete", Vector2(column + 1, row))
	# Check left
	if column > 0:
		emit_signal("damage_concrete", Vector2(column - 1, row))
	# Check up
	if row < height - 1:
		emit_signal("damage_concrete", Vector2(column, row + 1))
	# Check down
	if row < height + 1:
		emit_signal("damage_concrete", Vector2(column, row - 1))

func check_slime(column, row):
	# Check right
	if column < width - 1:
		emit_signal("damage_slime", Vector2(column + 1, row))
	# Check left
	if column > 0:
		emit_signal("damage_slime", Vector2(column - 1, row))
	# Check up
	if row < height - 1:
		emit_signal("damage_slime", Vector2(column, row + 1))
	# Check down
	if row < height + 1:
		emit_signal("damage_slime", Vector2(column, row - 1))

func damage_special(column, row):
	emit_signal("damage_ice", Vector2(column, row))
#	if is_in_array(ice_spaces, Vector2(column, row)):
#		print("damage_ice: " + str(column) + "," + str(row))
	emit_signal("damage_lock", Vector2(column, row))
	check_concrete(column, row)
	check_slime(column, row)

func match_color(color):
	for i in width:
		for j in height:
			if all_pieces[i][j] != null and !is_piece_sinker(i, j):
				if all_pieces[i][j].color == color:
					if all_pieces[i][j].is_column_bomb:
						match_all_in_column(i, j)
					if all_pieces[i][j].is_row_bomb:
						match_all_in_row(i, j)
					if all_pieces[i][j].is_adjacent_bomb:
						find_adjacent_pieces(i, j)
					match_and_dim(all_pieces[i][j])
					add_to_array(Vector2(i, j))
	color_bomb_used = true

func clear_board():
	cleared_board = true
	for i in width:
		for j in height:
			if all_pieces[i][j] != null and !is_piece_sinker(i, j):
				match_and_dim(all_pieces[i][j])
				add_to_array(Vector2(i, j))

func collapse_columns():
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !restricted_fill(Vector2(i, j)):
				for k in range(j + 1, height):
					if all_pieces[i][k] != null:
						all_pieces[i][k].move(grid_to_pixel(i, j))
						all_pieces[i][j] = all_pieces[i][k]
						all_pieces[i][k] = null
						break
	destroy_sinkers()
	get_parent().get_node("RefillTimer").start()

func refill_columns():
	if current_sinkers < max_sinkers:
		spawn_sinkers(max_sinkers - current_sinkers)
	streak += 1
	if streak == 100:
		emit_signal("maximum_streak_reached")
	for i in width:
		for j in height:
			if all_pieces[i][j] == null && !restricted_fill(Vector2(i, j)):
				# Choose a random number and sotere it
				var rand = randi() % possible_pieces.size()
				var piece = possible_pieces[rand].instance();
				var loops = 0;
				while(match_at(i, j, piece.color) && loops < 100):
					rand = randi() % possible_pieces.size()
					loops += 1;
					piece = possible_pieces[rand].instance();
				# Instance that piece from the array
				add_child(piece);
				piece.position = grid_to_pixel(i, j - y_offset)
				piece.move(grid_to_pixel(i,j))
				all_pieces[i][j] = piece;
	after_refill()

func after_refill():
	for i in width:
		for j in height:
			if all_pieces[i][j] != null:
				if match_at(i, j, all_pieces[i][j].color) or all_pieces[i][j].matched:
#				if match_at(i, j, all_pieces[i][j].color):
					find_matches()
					#get_parent().get_node("DestroyTimer").start()
					return
	if !damaged_slime:
		generate_slime()
	streak = 1
	move_checked = false
	damaged_slime = false
	color_bomb_used = false
	cleared_board = false
#	just_matched_in_column = false
#	just_matched_in_row = false
	if goals_met:
		$Timer.stop()
		emit_signal("open_game_win_panel")
	if is_deadlocked():
		$ShuffleTimer.start()
	if is_moves:
		if state != game_win:
			current_counter_value -= 1
			emit_signal("update_counter")
			if current_counter_value == 0:
				declare_game_over()
			else:
				state = move
	$HintTimer.start()

func generate_slime():
	# Make sure there are slime pieces on the board
	if slime_spaces.size() > 0:
		var slime_made = false
		var tracker = 0
		while !slime_made and tracker < 100:
			# Check a random slime
			var rand_num = floor(rand_range(0, slime_spaces.size()))
			var curr_x = slime_spaces[rand_num].x
			var curr_y = slime_spaces[rand_num].y
			var neighbour = find_normal_neighbour(curr_x, curr_y)
			if neighbour != null:
				# Turn neighbour into slime
				# Remove piece
				all_pieces[neighbour.x][neighbour.y].queue_free()
				# Set to null
				all_pieces[neighbour.x][neighbour.y] = null
				# Add spot to array of slimes
				slime_spaces.append(Vector2(neighbour.x, neighbour.y))
				# Send a signal to the slime holder to make a new slime
				emit_signal("make_slime", Vector2(neighbour.x, neighbour.y))
				slime_made = true
			tracker += 1

func check_restrictions(place):
	if is_piece_null(place.x, place.y):
		return true
	elif restricted_move(place):
		return true
	elif restricted_fill(place):
		return true
	elif is_ice_block(place):
		return true
	else:
		return false

func find_normal_neighbour(column, row):
	# Pick random direction
	var rand_dir = floor(rand_range(0, 3))

	# Check right first
	if rand_dir == 0 and is_in_grid(Vector2(column + 1, row)):
		if !check_restrictions(Vector2(column + 1, row)) and !is_piece_sinker(column + 1, row):
			return Vector2(column + 1, row)
	# Check left
	if rand_dir == 1 and is_in_grid(Vector2(column - 1, row)):
#		if !is_piece_null(column - 1, row) and !restricted_move(Vector2(column - 1, row)) and !restricted_fill(Vector2(column - 1, row)):
		if !check_restrictions(Vector2(column - 1, row)) and !is_piece_sinker(column - 1, row):
			return Vector2(column - 1, row)
	# Check up
	if rand_dir == 2 and is_in_grid(Vector2(column, row + 1)):
#		if !is_piece_null(column, row + 1) and !restricted_move(Vector2(column, row + 1)) and !restricted_fill(Vector2(column, row + 1)):
		if !check_restrictions(Vector2(column, row + 1)) and !is_piece_sinker(column, row + 1):
			return Vector2(column, row + 1)
	# Check down
	if rand_dir == 3 and is_in_grid(Vector2(column, row - 1)):
#		if !is_piece_null(column, row - 1) and !restricted_move(Vector2(column, row - 1)) and !restricted_fill(Vector2(column, row - 1)):
		if !check_restrictions(Vector2(column, row - 1)) and !is_piece_sinker(column, row - 1):
			return Vector2(column, row - 1)

func match_all_in_column(column, row):
	for i in height:
		if !is_piece_null(column, i) and !is_piece_sinker(column, i):
			if all_pieces[column][i].is_row_bomb:
				match_all_in_row(column, i)
			if all_pieces[column][i].is_adjacent_bomb:
				find_adjacent_pieces(column, i)
			if all_pieces[column][i].is_colour_bomb:
				match_color(all_pieces[column][row].color)
			all_pieces[column][i].matched = true

func match_all_in_row(column, row):
	for i in width:
		if !is_piece_null(i, row) and !is_piece_sinker(i, row):
			if all_pieces[i][row].is_column_bomb:
				match_all_in_column(i, row)
			if all_pieces[i][row].is_adjacent_bomb:
				find_adjacent_pieces(i, row)
			if all_pieces[i][row].is_colour_bomb:
				match_color(all_pieces[column][row].color)
			all_pieces[i][row].matched = true

func find_adjacent_pieces(column, row):
	for i in range(-1, 2):
		for j in range(-1, 2):
			if is_in_grid(Vector2(column + i, row + j)):
				if !is_piece_null(column + i, row + j) and !is_piece_sinker(column + i, row + j):
					if all_pieces[column + i][row + j].is_row_bomb:
						match_all_in_row(column, j)
					if all_pieces[column + i][row + j].is_column_bomb:
						match_all_in_column(column + i, row + j)
					if all_pieces[column + i][row + j].is_colour_bomb:
						match_color(all_pieces[column][row].color)
					all_pieces[column+i][row+j].matched = true

func destroy_sinkers():
	for i in width:
		if all_pieces[i][0] != null:
			if all_pieces[i][0].color == "None":
				all_pieces[i][0].matched = true
				current_sinkers -= 1

func copy_array(array_to_copy):
	var new_array = make_2d_array()
	for i in width:
		for j in height:
			new_array[i][j] = array_to_copy[i][j]
	return new_array

func clear_and_store_board():
	var holder_array = []
	for i in width:
		for j in height:
			if !is_piece_null(i, j):
				holder_array.append(all_pieces[i][j])
				all_pieces[i][j] = null
	return holder_array

func shuffle_board():
	var holder_array = clear_and_store_board()
	for i in width:
		for j in height:
			if !restricted_fill(Vector2(i, j)) and all_pieces[i][j] == null:
				# Choose a random number and store it
				var rand = floor(rand_range(0, holder_array.size()))
				var piece = holder_array[rand]
				var loops = 0
				while(match_at(i, j, piece.color) && loops < 100):
					rand = floor(rand_range(0, holder_array.size()))
					loops += 1;
					piece = holder_array[rand]
				piece.move(grid_to_pixel(i, j))
				all_pieces[i][j] = piece;
				holder_array.remove(rand)
	if is_deadlocked():
		$ShuffleTimer.start()
	state = move

func find_all_matches():
	var hint_holder = []
	var clone_array = copy_array(all_pieces)
	print("CLONE ARRAY")
	print (clone_array)
	for i in width:
		for j in height:
			if is_in_grid(Vector2(i, j)) and not clone_array[i][j] == null:
				if is_in_grid(Vector2(i+1, j+1)) and not clone_array[i+1][j+1] == null:
					if switch_and_check(Vector2(i, j), Vector2(1, 0), clone_array) and is_in_grid(Vector2(i + 1, j)):
						if hint_color != "":
							if hint_color == clone_array[i][j].color:
								hint_holder.append(clone_array[i][j])
							else:
								hint_holder.append(clone_array[i + 1][j])
					if switch_and_check(Vector2(i, j), Vector2(0, 1), clone_array) and is_in_grid(Vector2(i, j + 1)):
						if hint_color != "":
							if hint_color == clone_array[i][j].color:
								hint_holder.append(clone_array[i][j])
							else:
								hint_holder.append(clone_array[i][j + 1])
	return hint_holder

func generate_hint():
	var hints = find_all_matches()
	if hints != null:
		if hints.size() > 0:
			destroy_hint()
			var rand = randi() % hints.size()
			hint = hint_effect.instance()
			add_child(hint)
			hint.position = hints[rand].position
			hint.setup(hints[rand].get_node("Sprite").texture)

func destroy_hint():
	if hint:
		hint.queue_free()
		hint = null

func switch_pieces(place, direction, array):
	if is_in_grid(place) and !restricted_fill(place):
		if is_in_grid(place + direction) and !restricted_fill(place + direction):
			# Hold the piece that will be swapped
			var holder = array[place.x + direction.x][place.y + direction.y]
			# Set piece that is to be swapped as the original piece
			array[place.x + direction.x][place.y + direction.y] = array[place.x][place.y]
			# Set original piece as the held piece
			array[place.x][place.y] = holder

func is_deadlocked():
	# Create a copy of the all pieces array
	clone_array = copy_array(all_pieces)
	for i in width:
		for j in height:
			# Switch and check right
			if switch_and_check(Vector2(i,j), Vector2(1,0), clone_array):
#				print('able to swap right')
				return false
			# Switch and check up
			if switch_and_check(Vector2(i,j), Vector2(0,1), clone_array):
#				print('able to swap up')
				return false
	return true

func switch_and_check(place, direction, array):
	switch_pieces(place, direction, array)
	if find_matches(true, array):
		switch_pieces(place, direction, array)
		print('found matches')
		return true
	switch_pieces(place, direction, array)
	return false

func _on_DestroyTimer_timeout():
	#find_bombs()
	destroy_matched()

func _on_CollapseTimer_timeout():
	collapse_columns()

func _on_RefillTimer_timeout():
	refill_columns()

func _on_LockHolder_remove_lock(item):
	lock_spaces = remove_from_array(lock_spaces, item)

func _on_ConcreteHolder_remove_concrete(item):
	concrete_spaces = remove_from_array(concrete_spaces, item)

func _on_SlimeHolder_remove_slime(item):
	damaged_slime = true
	slime_spaces = remove_from_array(slime_spaces, item)

func _on_Timer_timeout():
	current_counter_value -=1
	emit_signal("update_counter")
	if current_counter_value == 0:
		if state != game_win:
			declare_game_over()
		$Timer.stop()

func declare_game_over():
	emit_signal("game_over")
	state = game_over

func _on_Grid_maximum_streak_reached():
	clear_board()

func _on_GoalHolder_game_win():
	state = game_win
	goals_met = true
	destroy_hint()
	$Timer.stop()

func _on_ShuffleTimer_timeout():
	shuffle_board()
	generate_hint()

func _on_BottomUI_random_color_bomb():

	var x = floor(rand_range(0, width))
	var y = floor(rand_range(0, height))
	var new_piece = all_pieces[x][y]

	for i in all_pieces:
		if !is_piece_null(x, y) and !is_color_bomb(all_pieces[x][y]):
			if !restricted_fill(Vector2(x, y)) and !restricted_move(Vector2(x, y)):
				damage_special(x, y)
				emit_signal("check_goal", new_piece.color)
				new_piece.matched = false
				change_bomb(3, new_piece)
			else:
				x = rand_range(0, width)
				y = rand_range(0, height)
				new_piece = all_pieces[x][y]

func _on_HintTimer_timeout():
	generate_hint()
