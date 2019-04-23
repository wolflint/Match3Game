extends Control

func _ready():
	$GameStartMenu.slide_in()
	print(Points.points)

func _on_SettingsMenu_back_button():
	$SettingsMenu.slide_out()
	$GameStartMenu.slide_in()

func _on_GameStartMenu_play_button_pressed():
	if Points.get_current_points() <= 0:
		return
	Points.remove_point()
	get_tree().change_scene("res://scenes/LevelSelectScene.tscn")


func _on_GameStartMenu_learn_button_pressed():
	$GameStartMenu.slide_out()
	$LearnMenu.slide_in()


func _on_GameStartMenu_settings_button_pressed():
	$GameStartMenu.slide_out()
	$SettingsMenu.slide_in()

func _on_LearnMenu_learn_button_pressed():
	$LearnMenu.slide_out()
	$MainLearnMenuSelectionPanel.slide_in()


func _on_LearnMenu_quiz_button_pressed():
	get_tree().change_scene("res://scenes/Quiz.tscn")


func _on_MainLearnMenuSelectionPanel_properties_button_pressed():
	$MainLearnMenuSelectionPanel.slide_out()
	$GameStartMenu.slide_in()


func _on_MainLearnMenuSelectionPanel_shapes_button_pressed():
	$MainLearnMenuSelectionPanel.slide_out()
	$GameStartMenu.slide_in()
