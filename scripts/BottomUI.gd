extends TextureRect

signal pause_game
signal random_color_bomb
var just_used_color_bonus = false

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Booster2_pressed():
#	if !just_used_color_bonus:
	emit_signal("random_color_bomb")
#		just_used_color_bonus = true
#		$ColorBombTimer.start()
		


func _on_ColorBombTimer_timeout():
	just_used_color_bonus = false
