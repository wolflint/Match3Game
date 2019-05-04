extends "res://scripts/BaseMenuPanel.gd"

onready var score_label = $TextureRect/VBoxContainer/Label

func _on_TopUI_final_score(score):
	print("Score on panel: " + str(score))
	score_label.text = str(score)

func _on_Grid_open_game_win_panel():
	slide_in()
	get_tree().paused = true
	


func _on_Quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene("res://scenes/GameMenu.tscn")


func _on_Continue_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene(get_parent().next_level)
