extends "res://scripts/BaseMenuPanel.gd"

func _on_QuitButton_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_RestartButton_pressed():
	if GameDataManager.get_current_points() <= 0:
		return
	GameDataManager.remove_point()
	get_tree().reload_current_scene()

func _on_Grid_game_over():
	slide_in()
	yield($AnimationPlayer, "animation_finished")
	if GameDataManager.get_current_points() <= 0:
		$MarginContainer/TextureRect/HBoxContainer/RestartButton.set("disabled", true)
