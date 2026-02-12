extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalSignal.near_blackjack.emit(true)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		GlobalSignal.near_blackjack.emit(false)
