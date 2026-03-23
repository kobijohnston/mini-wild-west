extends Control

var item

var clickable = false
var clicked = false

@onready var item_sprite: TextureRect = $"Item Sprite"

func _process(delta: float) -> void:
	if clickable:
		if Input.is_action_just_pressed("left click"):
			clicked = true
	
	if clicked:
		position = get_global_mouse_position()
	
func set_sprite(sprite_filepath):
	if sprite_filepath == "false":
		item_sprite.texture = load("res://icon.svg")
		return
	item_sprite.texture = load(sprite_filepath)

func _on_mouse_entered():
	clickable = true

func _on_mouse_exited():
	clickable = false
