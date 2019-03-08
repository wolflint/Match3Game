extends Node2D

func change_color(effect_color):
	match effect_color:
		"blue": $Particles2D.modulate = Color(0.337, 0.596, 0.8, 2)
		"yellow": $Particles2D.modulate = Color(0.98, 0.796, 0.243, 2)
		"green": $Particles2D.modulate = Color(0.286, 0.655, 0.565, 2)
		"orange": $Particles2D.modulate = Color(0.933, 0.556, 0.18, 2)
		"lgreen": $Particles2D.modulate = Color(0.592, 0.855, 0.247, 2)
		"pink": $Particles2D.modulate = Color(0.863, 0.29, 0.482, 2)
