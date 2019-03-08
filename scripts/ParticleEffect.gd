extends Node2D

func change_color(effect_color):
	match effect_color:
		"blue": $Particles2D.modulate = Color(0.337, 0.596, 0.8, 1)
		"yellow": $Particles2D.modulate = Color(0.98, 0.796, 0.243, 1)
		"green": $Particles2D.modulate = Color(0.286, 0.655, 0.565, 1)
