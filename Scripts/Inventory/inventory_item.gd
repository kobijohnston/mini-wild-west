extends Control

var item
var dragging = false

signal item_dropped(item)

@onready var item_sprite: TextureRect = $"Item Sprite"

func _process(delta: float) -> void:
	if dragging:
		drag()
func set_sprite(sprite_filepath):
	if sprite_filepath == "false":
		item_sprite.texture = load("res://icon.svg")
		return
	item_sprite.texture = load(sprite_filepath)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
			else:
				dragging = false
				drop()
		

func drag():
	global_position = get_global_mouse_position()

func drop():
	item_dropped.emit(self)
