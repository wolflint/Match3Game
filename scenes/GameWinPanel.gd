extends "res://scripts/BaseMenuPanel.gd"

func _on_ContinueButton_pressed():
	get_tree().reload_current_scene()

func _on_GoalHolder_game_win():
	slide_in()
