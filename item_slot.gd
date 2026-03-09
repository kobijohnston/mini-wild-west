extends Area2D

var type = GlobalEnums.Item_Type.BASE
var item

func add_item(item):
	if item["sprite"] == Sprite2D:
		add_child(item["sprite"])
