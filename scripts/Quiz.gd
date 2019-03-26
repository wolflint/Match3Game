extends Control


onready var question_database = $QuestionDatabase
onready var question_label = $MarginContainer/VBoxContainer/Label
var all_questions = []
var used_questions = []
var current_question

func _ready():
	for i in question_database.get_child_count():
		all_questions.append(question_database.get_child(i))

	current_question = get_question()
	update_label(current_question)

func get_question():
	if all_questions.empty():
		return
	randomize()
	var rand = randi() % all_questions.size()
	var new_question = all_questions[rand]

	if check_if_in_array(used_questions, new_question):
		new_question = get_question()

	all_questions.remove(rand)
	used_questions.append(new_question)
	return new_question

func update_label(current_question):
	if current_question != null:
		question_label.text = current_question.question


func check_if_in_array(array,item):
	if not array.empty():
		for i in array.size():
			if item == array[i]:
				return true
			continue
		return false

func _on_Button_pressed():
	current_question = get_question()
	update_label(current_question)
