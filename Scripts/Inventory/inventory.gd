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

func _process(delta):
	
	if Input.is_action_just_pressed("select"):
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
			print("Slot created")
			if items.size() > 0:
				print("adding item")
				var inventory_item = inventory_item_scene.instantiate()
				add_child(inventory_item)
				inventory_item.set_sprite(items[0]["sprite"])
				inventory_item.position = slot.position
				items.remove_at(0)
				print("item added")
			item_row.append(slot)
		
		item_slots.append(item_row)
		slot_y += 96
	
	slot_y = FIRST_SLOT_Y
	print("DONE DONE DONE DONE DONE")
