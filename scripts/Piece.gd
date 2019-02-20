extends Node2D

export (String) var color;
export (Texture) var row_texture
export (Texture) var column_texture
export (Texture) var adjacent_texture
export (Texture) var colour_bomb_texture

var is_row_bomb = false
var is_column_bomb = false
var is_adjacent_bomb = false
var is_colour_bomb = false

var move_tween;
var matched = false

func _ready():
	move_tween = $Move_Tween

func move(target):
	move_tween.interpolate_property(self, "position", position, target, .5, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	move_tween.start()

func make_column_bomb():
	is_column_bomb = true
	$Sprite.texture = column_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_row_bomb():
	is_row_bomb = true
	$Sprite.texture = row_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_adjacent_bomb():
	is_adjacent_bomb = true
	$Sprite.texture = adjacent_texture
	$Sprite.modulate = Color(1, 1, 1, 1)

func make_colour_bomb():
	is_colour_bomb = true
	$Sprite.texture = colour_bomb_texture
	$Sprite.modulate = Color(1, 1, 1, 1)
	color = "Color"

func dim():
	var sprite = $Sprite
	sprite.modulate = Color(1, 1, 1, .5)