extends "res://scripts/BaseMenuPanel.gd"

onready var score_label = $TextureRect/VBoxContainer/Label

func _on_ContinueButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_TopUI_final_score(score):
	score_label.text = str(score)

func _on_Grid_open_game_win_panel():
	slide_in()
