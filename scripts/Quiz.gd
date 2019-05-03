extends Control


onready var question_database = $QuestionDatabase
onready var question_label = $TextureRect/VBoxContainer/QuestionLbl
onready var answer_buttons = $TextureRect/VBoxContainer/AnswerButtons.get_children()
onready var shape_diagram = $TextureRect/VBoxContainer/HBoxContainer/ShapeDiagram
var all_questions = []
var used_questions = []
var current_question
var current_answers = []
var total_questions = 0
var score = 0
const PASS = 0.5
const MERIT = 0.7
const DISTINCTION = 1.0

func _ready():
	while len(all_questions) < 5:
		randomize()
		var rand = randi() % len(question_database.get_children())
		if all_questions.has(question_database.get_child(rand)):
			continue
		all_questions.append(question_database.get_child(rand))

	current_question = get_question()
	current_answers = get_answers(current_question)
	update_label(current_question)
	update_button_text(current_answers)

func get_question():
	if all_questions.empty():
		var suffix = "\n Your score is : %s/%s" % [score, total_questions]
		# Change button answers:
		for i in 3:
			answer_buttons[i].text = ""
		answer_buttons[3].text = "Try again!"

		if score == 5:
			question_label.text = "Perfect score! I'll charge your battery." + suffix
			GameDataManager.add_points(3)
		elif score == 4:
			question_label.text = "Nice score! I'll charge your battery a bit." + suffix
			GameDataManager.add_points(2)
		elif score == 3:
			question_label.text = "Good attempt kid, I'll charge your battery a little bit." + suffix
			GameDataManager.add_points(1)
		else:
			question_label.text = "Nice try, but you need to learn a bit more. Try again." + suffix
		print("Current Points: " + str(GameDataManager.get_current_points()))
		GameDataManager.save_data()

		return
	randomize()
	var rand = randi() % all_questions.size()
	var new_question = all_questions[rand]

	if check_if_in_array(used_questions, new_question):
		new_question = get_question()

	all_questions.remove(rand)
	used_questions.append(new_question)
	total_questions += 1
	return new_question

func get_answers(current_question):
	var new_current_answers = []
	if current_question != null:
		for i in current_question.get_child_count():
			var new_answer = current_question.get_child(i)
#			print(new_answer)
			new_current_answers.append(new_answer)
#			print(new_current_answers)
		return new_current_answers

func update_label(current_question):
	if current_question != null:
		question_label.text = current_question.question
		shape_diagram.texture = current_question.diagram

func update_button_text(current_answers):
	if current_answers != null:
		for i in current_answers.size():
			answer_buttons[i].text = current_answers[i].answer
			print(current_answers[i])
#			answer_buttons[0].text = "This is a test man!"

func check_if_in_array(array,item):
	if not array.empty():
		for i in array.size():
			if item == array[i]:
				return true
			continue
		return false

func next_question():
	current_question = get_question()
	current_answers = get_answers(current_question)
	update_label(current_question)
	update_button_text(current_answers)


func _on_Button1_pressed():
	if not current_answers:
		return
	if current_answers[0].is_correct:
		score += 1
	next_question()


func _on_Button2_pressed():
	if not current_answers:
		return
	if current_answers[1].is_correct:
		score += 1
	next_question()


func _on_Button3_pressed():
	if not current_answers:
		get_tree().change_scene("res://scenes/GameMenu.tscn")
		return
	if current_answers[2].is_correct:
		score += 1
	next_question()


func _on_Button4_pressed():
	if not current_answers:
		get_tree().reload_current_scene()
		return
	if current_answers[3].is_correct:
		score += 1
	next_question()


func _on_Home_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")
