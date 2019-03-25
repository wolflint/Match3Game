extends Node2D

func change_color(effect_color):
	match effect_color:
		"blue": $Particles2D.modulate = Color("#0057e7")
		"yellow": $Particles2D.modulate = Color("#ffa700")
		"green": $Particles2D.modulate = Color("#008744")
		"orange": $Particles2D.modulate = Color("#FFA500")
		"lgreen": $Particles2D.modulate = Color("#00FF00")
		"pink": $Particles2D.modulate = Color("#FF00FF")
		"red": $Particles2D.modulate = Color("#FF0000")
		"purple": $Particles2D.modulate = Color("#800080")
