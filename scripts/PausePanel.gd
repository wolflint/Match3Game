extends "res://scripts/BaseMenuPanel.gd"

func _on_Quit_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/GameMenu.tscn")
	GameDataManager.save_data()

func _on_Continue_pressed():
	get_tree().paused = false
	slide_out()

func _on_BottomUI_pause_game():
	slide_in()
