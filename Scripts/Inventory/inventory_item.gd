extends Control

var item

var clicked = false
var dragging = false

@onready var item_sprite: TextureRect = $"Item Sprite"


func set_sprite(sprite_filepath):

	item_sprite.texture = load(sprite_filepath)
