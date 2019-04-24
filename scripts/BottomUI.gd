extends TextureRect

signal pause_game
signal random_color_bomb

var game_over = false

# Speech
onready var speech_bubble = $Speech
onready var speech_label = $Speech/Label 
onready var speech_timer = $Speech/SpeechTimer

var speech_text = {
	"positive": {
		0: "Good job!",
		1: "You're really good at this!",
		2: "Nice one!",
		3: "You're doing great!",
		4: "You're a true shape-shifter!"
	},
	"negative": {
		0: "Better luck next time!",
		1: "You've got this! Try again.",
		2: "That was close!",
	},
	"tutorial": {
		0: "Hey you seem smart...",
		1: "Please help me recharge my battery.",
		2: "Match 3 or more shapes to gain charge.",
		3: "Some levels have goals, try collecting them."
	}
}

func _on_Pause_pressed():
	if not game_over:
		emit_signal("pause_game")
		get_tree().paused = true


func _on_ColourBombBooster_pressed() -> void:
	if Points.points > 0 and not game_over:
		Points.remove_point()
		emit_signal("random_color_bomb")
		print(Points.points)


func _on_Grid_print_positive_message():
	randomize()
	var rand = randi() % len(speech_text["positive"].values())
	speech_label.text = speech_text["positive"][rand]
	speech_bubble.show()
	speech_timer.start()
	yield(speech_timer, "timeout")
	speech_bubble.hide()


func _on_Grid_game_over():
	game_over = true
	randomize()
	var rand = randi() % len(speech_text["negative"].values())
	speech_label.text = speech_text["negative"][rand]
	speech_bubble.show()
	speech_timer.start()
	yield(speech_timer, "timeout")
	speech_bubble.hide()
