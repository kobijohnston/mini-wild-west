extends Area2D

var type = GlobalEnums.Item_Type.BASE
var has_item = false
var mouse_hovering = false

var inventory_item_scene = preload("res://Scenes/Menus/Inventory/inventory_item.tscn")
@onready var marker_2d: Marker2D = $Marker2D

func add_item(item):
	
	var inventory_item = inventory_item_scene.instantiate()
	add_child(inventory_item)
	inventory_item.item_dropped.connect(_on_item_dropped) # Do this in inventory.gd instead? iterate through and do it for each item in inv 
	inventory_item.set_sprite(item["sprite"])
	has_item = true

func remove_item():

	if has_item:
		for child in get_children():
			if child.is_in_group("Item"):
				child.queue_free()
				return
	
	print("ERROR: No item found to remove")

func _on_item_dropped(item):
	if mouse_hovering and not has_item:
		add_item(item)
		
func _on_mouse_entered() -> void:
	mouse_hovering = true

func _on_mouse_exited() -> void:
	mouse_hovering = false
