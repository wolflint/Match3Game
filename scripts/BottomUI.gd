extends TextureRect

signal pause_game
signal random_color_bomb
var just_used_color_bonus = false

func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Booster2_pressed():
	if Points.points > 0:
		Points.remove_point()
		emit_signal("random_color_bomb")
		print(Points.points)
