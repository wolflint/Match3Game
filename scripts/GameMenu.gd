extends Control

func _ready():
	$GameStartMenu.slide_in()

func _on_SettingsMenu_back_button():
	$SettingsMenu.slide_out()
	$GameStartMenu.slide_in()

func _on_GameStartMenu_play_button_pressed():
	get_tree().change_scene("res://scenes/levels/GameWindow.tscn")


func _on_GameStartMenu_learn_button_pressed():
	pass # Replace with function body.


func _on_GameStartMenu_settings_button_pressed():
	$GameStartMenu.slide_out()
	$SettingsMenu.slide_in()