extends CanvasLayer

const MAX_ITEM_ROWS = 5
const MAX_ITEM_COLUMNS = 3
 # 640, 320 
const FIRST_SLOT_X = 640
const FIRST_SLOT_Y = 320
var slot_x = FIRST_SLOT_X
var slot_y = FIRST_SLOT_Y

var item_slots = []

var item_slot_scene = preload("res://Scenes/Menus/Inventory/item_slot.tscn")
var inventory_item_scene = preload("res://Scenes/Menus/Inventory/inventory_item.tscn")

var configured = false
var populated = false

func _process(delta):
	
	if visible and Input.is_action_just_pressed("quit"):
		visible = false
		GlobalSignal.unpause.emit()
		
func configure(items): # Creates item slots and fills them with items from player's inventory
	
	item_slots.clear()
	
	for r in MAX_ITEM_ROWS:
		var item_row = []
		slot_x = FIRST_SLOT_X
		for c in MAX_ITEM_COLUMNS:
			var slot = item_slot_scene.instantiate()
			add_child(slot)
			slot.position.x = slot_x
			slot.position.y = slot_y
			slot_x += 96
			item_row.append(slot)
		
		item_slots.append(item_row)
		slot_y += 96
		
	slot_y = FIRST_SLOT_Y
	
	configured = true
	
	populate_inventory(items)
	
func populate_inventory(items):
	
	if not configured:
		print("ERROR: Inventory not configured")
		return
		
	if populated:
		clear_inventory()
				
	var current_slot_row = 0
	var current_slot_column = 0
	
	var item_index = 0
	
	for item in items:
		if items.size() > 0:
			
			var inventory_item = inventory_item_scene.instantiate()
			add_child(inventory_item)
			inventory_item.set_sprite(items[item_index]["sprite"])
			inventory_item.position = item_slots[current_slot_row][current_slot_column].position
			
			if current_slot_column < 2:
				current_slot_column += 1
			else:
				current_slot_row += 1
				current_slot_column = 0
			item_index += 1
			print("ITEM ADDED: " + item["name"])
	populated = true

func clear_inventory():
	var children = get_children()
	for child in children:
		if child.is_in_group("Item"):
			child.queue_free()
