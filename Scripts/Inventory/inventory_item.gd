extends Control

var item

var clicked = false
var hovering = false
var dragging = false
var original_position: Vector2

@onready var item_sprite: TextureRect = $"Item Sprite"

func _process(delta: float) -> void:
	if hovering:
		if Input.is_action_pressed("left click"):
			dragging = true
		elif Input.is_action_just_released("left click"):
			dragging = false
			position = original_position
			
	if dragging:
		print("Dragging")
		position = get_global_mouse_position()

func set_sprite(sprite_filepath):
	if sprite_filepath == "false":
		item_sprite.texture = load("res://icon.svg")
		return
	item_sprite.texture = load(sprite_filepath)

func _on_mouse_entered() -> void:
	original_position = position
	hovering = true

func _on_mouse_exited() -> void:
	hovering = false
