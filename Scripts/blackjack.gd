extends CanvasLayer

enum Game_State {SETUP, BET, DEAL, PLAYER_TURN, DEALER_TURN}
var current_state = Game_State.SETUP
var deck = Deck.new()

@onready var betting: Control = $Betting

var player = {
	"hand": [],
	"bet": 0,
	"standing": false,
	"bust": false
}

var dealer = {
	"hand": [],
	"standing": false,
	"bust": false
}

func _ready() -> void:
	
	pass

func _process(delta: float) -> void:
	
	match current_state:
		Game_State.SETUP:
			pass
		Game_State.BET:
			pass
		Game_State.DEAL:
			pass
		Game_State.PLAYER_TURN:
			pass
		Game_State.DEALER_TURN:
			pass
	pass

func setup_game():
	
	player = {
		"hand": [],
		"bet": 0,
		"standing": false,
		"bust": false
	}
	
	dealer = {
		"hand": [],
		"standing": false,
		"bust": false
	}
	
	change_state(Game_State.BET)
	
func bet():
	betting.visible = true
	
func change_state(state):
	current_state = state

func _on_quit_button_pressed() -> void:
	GlobalSignal.unpause.emit()
	queue_free()
	
