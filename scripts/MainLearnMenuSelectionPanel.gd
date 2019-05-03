extends 'BaseMenuPanel.gd'

signal properties_button_pressed
signal shapes_button_pressed



func _on_PropertiesButton_pressed():
	emit_signal("properties_button_pressed")


func _on_ShapesButton_pressed():
	emit_signal("shapes_button_pressed")
