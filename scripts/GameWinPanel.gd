extends "res://scripts/BaseMenuPanel.gd"

onready var score_label = $TextureRect/VBoxContainer/Label

func _on_ContinueButton_pressed():
	get_tree().paused = false
	get_tree().change_scene(get_parent().next_level)

func _on_TopUI_final_score(score):
	print("Score on panel: " + str(score))
	score_label.text = str(score)

func _on_Grid_open_game_win_panel():
	slide_in()
