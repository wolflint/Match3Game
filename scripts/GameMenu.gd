extends Control

func _ready():
	# Main menu panel active
	$Main.slide_in()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Main_settings_pressed():
	$Main.slide_out()
	$SettingsMenu.slide_in()


func _on_SettingsMenu_back_button():
	$SettingsMenu.slide_out()
	$Main.slide_in()


func _on_Main_play_pressed():
	get_tree().change_scene("res://scenes/levels/Level1.tscn")