extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("slide_in")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/ShapeSelection.tscn")


func _on_Home_pressed():
	$AnimationPlayer.play_backwards("slide_in")
	yield($AnimationPlayer, "animation_finished")
	get_tree().change_scene("res://scenes/GameMenu.tscn")
