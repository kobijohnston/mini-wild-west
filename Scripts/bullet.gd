extends Area2D

var speed = 400
var shooter
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += Vector2.RIGHT.rotated(rotation) * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	
	if body == shooter:
		return
		
	if body.has_method("take_damage"):
		body.take_damage() #EXAMPLE fill this in later, doesnt do anything atm
	queue_free()
