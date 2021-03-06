extends "BaseMenuPanel.gd"

signal sound_changed
signal back_button

export (Texture) var sound_on_texture
export (Texture) var sound_off_texture

func _on_Button1_pressed():
	ConfigManager.sound_on = !ConfigManager.sound_on
	Music.set("playing", ConfigManager.sound_on)
	change_sound_texture()
	ConfigManager.save_config()

func change_sound_texture():
	if ConfigManager.sound_on == true:
		$MarginContainer/GraphicAndButtons/Buttons/Button1.texture_normal = sound_on_texture
	else:
		$MarginContainer/GraphicAndButtons/Buttons/Button1.texture_normal = sound_off_texture


func _on_Button2_pressed():
	emit_signal("back_button")


func _on_GameMenu_read_sound() -> void:
	change_sound_texture()