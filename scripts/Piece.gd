extends Node2D

export (String) var color;
var move_tween;
var matched = false

func _ready():
	move_tween = $Move_Tween

func move(target):
	move_tween.interpolate_property(self, "position", position, target, .5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func dim():
	var sprite = $Sprite
	sprite.modulate = Color(1, 1, 1, .5)