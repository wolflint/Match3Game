extends "res://scripts/BaseMenuPanel.gd"

signal play_button_pressed
signal learn_button_pressed
signal settings_button_pressed

onready var play_button = $MarginContainer/GraphicAndButtons/Buttons/PlayButton
onready var learn_button = $MarginContainer/GraphicAndButtons/Buttons/LearnButton
onready var settings_button = $MarginContainer/GraphicAndButtons/Buttons/SettingsButton

func _ready():
	play_button.connect("pressed", self, "_on_PlayButton_pressed")
	learn_button.connect("pressed", self, "_on_LearnButton_pressed")
	settings_button.connect("pressed", self, "_on_SettingsButton_pressed")

func _on_PlayButton_pressed():
	self.emit_signal("play_button_pressed")

func _on_LearnButton_pressed():
	self.emit_signal("learn_button_pressed")

func _on_SettingsButton_pressed():
	self.emit_signal("settings_button_pressed")
