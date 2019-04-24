extends TextureRect

signal pause_game
signal random_color_bomb

# Speech
onready var speech_bubble = $Speech
onready var speech_label = $Speech/Label 
onready var speech_timer = $Speech/SpeechTimer

var speech_text = {
	"positive": {
		1: "Good job!",
		2: "You're really good at this!",
		3: "Nice one!",
		4: "You're doing great!",
		5: "You're a true shape-shifter!"
	},
	"negative": {
		1: "Better luck next time!",
		2: "You've got this! Try again.",
		3: "That was close!",
	},
	"tutorial": {
		1: "Hey you seem smart...",
		2: "Please help me recharge my battery.",
		3: "Match 3 or more shapes to gain charge.",
		4: "Some levels have goals, try collecting them."
	}
}

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true


func _on_ColourBombBooster_pressed() -> void:
	if Points.points > 0:
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
