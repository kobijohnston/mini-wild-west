extends Area2D

enum Shop { AMARILLO_GENERAL, AMARILLO_GUNS }

@export var this_shop = Shop.AMARILLO_GENERAL

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalSignal.near_shop_desk.emit(this_shop, true)



func _on_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
