extends CanvasLayer

enum Game_State {SETUP, BET, DEAL, PLAYER_TURN, DEALER_TURN}
var current_state = Game_State.SETUP
var deck = Deck.new()
var hands_dealt = false
@onready var betting: Control = $Betting
@onready var bet_button: Button = $"Betting/Bet Button"
@onready var bet_value: SpinBox = $Betting/SpinBox

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
			setup_game()
		Game_State.BET:
			bet()
		Game_State.DEAL:
			if not hands_dealt:
				deal()
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
	
func deal():
	dealer["hand"].append(deck.draw_card())
	dealer["hand"].append(deck.draw_card())
	#figure out drawing, use signal? also figure out face down card
	
func change_state(state):
	current_state = state

func _on_quit_button_pressed() -> void:
	GlobalSignal.unpause.emit()
	queue_free()
	
func _on_bet_button_pressed() -> void:
	player["bet"] = bet_value
	betting.visible = false
	change_state(Game_State.DEAL)
