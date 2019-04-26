extends Control

onready var shape_buttons = $VBoxContainer/Shapes

func _ready():
	$AnimationPlayer.play("slide_in")
	for shape in shape_buttons.get_children():
		shape.connect("pressed", self, "_on_" + shape.name + "_pressed")

func _on_Square_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Square.tscn")

func _on_Circle_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Circle.tscn")

func _on_Triangle_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Triangle.tscn")

func _on_Rhombus_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Rhombus.tscn")

func _on_Rectangle_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Rectangle.tscn")

func _on_Pentagon_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Pentagon.tscn")

func _on_Hexagon_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Hexagon.tscn")

func _on_Parallelogram_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/learn-shapes/Parallelogram.tscn")

func _on_Home_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/GameMenu.tscn")
