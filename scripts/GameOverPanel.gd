extends "res://scripts/BaseMenuPanel.gd"

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_RestartButton_pressed():
	if points.points <= 0:
		return
	points.points -= 1
	get_tree().reload_current_scene()

func _on_Grid_game_over():
	slide_in()
