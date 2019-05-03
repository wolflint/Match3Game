tool
extends TextureProgress

func _ready():
	GameDataManager.connect("points_changed", self, "_on_points_changed")
	update_indicator()

func update_indicator():
	var current_points = GameDataManager.get_current_points()
	$Label.text = str(GameDataManager.get_current_points())
	$Tween.interpolate_property(self, "value", value, current_points , 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")

func _on_points_changed():
	update_indicator()

