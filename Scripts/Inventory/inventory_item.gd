extends Control

var item
var dragging = false

@onready var item_sprite: TextureRect = $"Item Sprite"

func set_sprite(sprite_filepath):
	if sprite_filepath == "false":
		item_sprite.texture = load("res://icon.svg")
		return
	item_sprite.texture = load(sprite_filepath)

		
