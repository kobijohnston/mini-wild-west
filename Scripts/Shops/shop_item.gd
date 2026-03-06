extends Control

var shop_item = {
	"name": "",
	"price": 0,
	"quantity": 0,
	"description": ""
}

var item

var hovering = false

@onready var item_name: Label = $"Item Name"
@onready var price: Label = $Price
@onready var background: ColorRect = $ColorRect


func config(i, quantity):
	
	item = i
	shop_item["name"] = item["name"]
	shop_item["price"] = item["price"]
	shop_item["quantity"] = quantity
	shop_item["description"] = item["description"]
	print("Adding:", item["name"])

	draw_item()
	
func draw_item():
	item_name.text = shop_item["name"]
	price.text = "$" + str(shop_item["price"])

func update_quantity(quantity):
	shop_item["quantity"] += quantity

func _on_area_2d_mouse_entered() -> void:
	hovering = true
	background.color.a = 0.5
	print("Mouse entered")
	
func _on_area_2d_mouse_exited() -> void:
	hovering = false
	background.color.a = 1
	print("mouse exited")

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if hovering:
		if event is InputEventMouseButton and event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				background.color = Color.AQUA
		elif event is InputEventMouseButton and event.is_released():
			if event.button_index == MOUSE_BUTTON_LEFT:
				background.color = Color.WHITE
				GlobalSignal.item_selected.emit(self)
