extends CanvasLayer

enum Game_State {SETUP, BET, DEAL, PLAYER_TURN, DEALER_TURN}
var deck = Deck.new()
func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	pass

func _on_quit_button_pressed() -> void:
	queue_free()
