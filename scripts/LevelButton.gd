extends Node2D

# Level details
export (int) var level
export (String) var level_to_load
export (bool) var enabled
export (bool) var score_goal_met

# Textures
export (Texture) var blocked_texture
export (Texture) var blocked_pressed_texture
export (Texture) var open_texture
export (Texture) var open_pressed_texture
export (Texture) var goal_met
export (Texture) var goal_not_met

onready var level_label = $TextureButton/Label
onready var button = $TextureButton
onready var star = $Sprite

func _ready() -> void:
	if GameDataManager.save_data["level_data"].has(level):
		enabled = GameDataManager.save_data["level_data"][level]["unlocked"]
	else:
		enabled = false
	setup()

func setup():
	level_label.text = str(level)
	if enabled:
		button.texture_normal = open_texture
		button.texture_pressed = open_pressed_texture
	else:
		button.texture_normal = blocked_texture
		button.texture_pressed = blocked_pressed_texture

	if score_goal_met:
		star.texture = goal_met
	else:
		star.texture = goal_not_met

func _on_TextureButton_pressed() -> void:
	if enabled:
		if GameDataManager.save_data["points"] <= 0:
			return
		GameDataManager.remove_point()
		get_tree().change_scene(level_to_load)
