extends TextureRect

onready var score_label = $Score/VBoxContainer/ScoreLabel
onready var score_bar = $Score/VBoxContainer/ScoreBar
onready var counter_label = $Counter/CounterLabel
onready var goal_container = $GoalContainer/HBoxContainer

export (PackedScene) var goal_prefab

var current_score = 0
var current_count = 0
signal final_score

func _ready():
	_on_Grid_update_score(current_score)

func _on_Grid_update_score(amount_to_change):
	current_score += amount_to_change
	update_score_bar()
	score_label.text = str(current_score)


func _on_Grid_update_counter(amount_to_change = -1):
	current_count += amount_to_change
	counter_label.text = str(current_count)

func setup_score_bar(max_score):
	score_bar.max_value = max_score

func update_score_bar():
	score_bar.value = current_score

func make_goal(new_max, new_texture, new_value):
	var current = goal_prefab.instance()
	goal_container.add_child(current)
	current.set_goal_values(new_max, new_texture, new_value)

func _on_Grid_setup_max_score(max_score):
	setup_score_bar(max_score)


func _on_GoalHolder_create_goal(new_max, new_texture, new_value):
	make_goal(new_max, new_texture, new_value)

func _on_Grid_check_goal(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)
	pass # replace with function body


func _on_IceHolder_break_ice(goal_type):
	for i in goal_container.get_child_count():
		goal_container.get_child(i).update_goal_values(goal_type)

func _on_Grid_open_game_win_panel():
	emit_signal("final_score", current_score)
