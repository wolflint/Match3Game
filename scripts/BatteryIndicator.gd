extends TextureProgress

func _ready():
	GameDataManager.connect("points_changed", self, "_on_points_changed")
	update_indicator()

func update_indicator():
	value = GameDataManager.get_current_points()
	$Label.text = str(GameDataManager.get_current_points())

func _on_points_changed():
	update_indicator()

