tool
extends TextureProgress

func _ready():
	GameDataManager.connect("points_changed", self, "_on_points_changed")
	update_indicator()

func update_indicator():
	var current_value = value
	value = GameDataManager.get_current_points()
	$Label.text = str(GameDataManager.get_current_points())
	$Tween.interpolate_property(self, "value", current_value, GameDataManager.get_current_points(), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_OUT)

func _on_points_changed():
	update_indicator()

