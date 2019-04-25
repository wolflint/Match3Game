extends 'BaseMenuPanel.gd'

signal learn_button_pressed
signal quiz_button_pressed
signal back_button_pressed

func _on_LearnButton_pressed():
	emit_signal("learn_button_pressed")


func _on_QuizButton_pressed():
	emit_signal("quiz_button_pressed")


func _on_Back_pressed():
	emit_signal("back_button_pressed")
