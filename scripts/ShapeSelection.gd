extends Control

onready var shape_buttons = $VBoxContainer/Shapes

func _ready():
	for shape in shape_buttons.get_children():
		shape.connect("pressed", self, "_on_" + shape.name + "_pressed")

func _on_Square_pressed():
	print("Square")

func _on_Circle_pressed():
	print("Circle")

func _on_Triangle_pressed():
	print("Triangle")

func _on_RightTriangle_pressed():
	print("RightTriangle")

func _on_Rectangle_pressed():
	print("Rectangle")

func _on_Pentagon_pressed():
	print("Pentagon")

func _on_Hexagon_pressed():
	print("Hexagon")

func _on_Parallelogram_pressed():
	print("Parallelogram")

func _on_Home_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")
