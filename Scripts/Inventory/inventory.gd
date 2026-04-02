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
		
func configure(items): # Creates item slots and populates using populate_inventory

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
		
	for i in items:
		add_item(i)
	
	populated = true
	
func add_item(item):
	
	for row in MAX_ITEM_ROWS:
		for column in MAX_ITEM_COLUMNS:
			if item_slots[row][column].has_item:
				pass
			else:
				item_slots[row][column].add_item(item)
				return

func clear_inventory():
	
	for row in MAX_ITEM_ROWS:	
		for column in MAX_ITEM_COLUMNS:
			if item_slots[row][column].has_item:
				item_slots[row][column].remove_item()
				item_slots[row][column].has_item = false
