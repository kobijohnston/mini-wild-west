extends CanvasLayer

enum Game_State {SETUP, BET, DEAL, PLAYER_TURN, DEALER_TURN, RESULT}
enum Role { PLAYER, DEALER }
var current_state = Game_State.SETUP
var deck = Deck.new()
var hands_dealt = false
var dealer_started = false
@onready var betting: Control = $Betting
@onready var bet_button: Button = $"Betting/Bet Button"
@onready var bet_value: SpinBox = $"Betting/Bet Value"
@onready var result_label: Label = $Result

signal draw_card_sprite(card, role)
signal dealer_started_signal

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
			player_turn()
		Game_State.DEALER_TURN:
			if not dealer_started:
				dealer_turn()
		Game_State.RESULT:
			result()
	

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
	
	deck.create_deck()
	deck.deck.shuffle()
	change_state(Game_State.BET)
	
func bet():
	betting.visible = true
	
func deal():
	dealer["hand"].append(deck.draw_card())
	dealer["hand"].append(deck.draw_card())
	
	player["hand"].append(deck.draw_card())
	player["hand"].append(deck.draw_card())
	
	for card in dealer["hand"]:
		if card == dealer["hand"][1]:
			card["face down"] = true
		draw_card_sprite.emit(card, Role.DEALER)
	
	for card in player["hand"]:
		draw_card_sprite.emit(card, Role.PLAYER)
	
	hands_dealt = true
	change_state(Game_State.PLAYER_TURN)
	
func player_turn():
	var hand_value = calculate_hand_value(player["hand"])
	print(hand_value)
	if hand_value == 21:
		player["standing"] = true
	elif hand_value > 21:
		player["bust"] = true
	if player["standing"] or player["bust"]:
		change_state(Game_State.DEALER_TURN)

func dealer_turn():
	
	for card in dealer["hand"]:
		card["face down"] = false
		
	dealer_started = true
	dealer_started_signal.emit()
	if player["bust"]:
		change_state(Game_State.RESULT)
		
	var hand_value = calculate_hand_value(dealer["hand"])
	if hand_value < 17:
		var new_card = deck.draw_card()
		dealer["hand"].append(new_card)
		draw_card_sprite.emit(new_card, Role.DEALER)
	if hand_value >= 17:
		dealer["standing"] = true
	if hand_value > 21:
		dealer["bust"] = true
		print("Dealer Bust")
	if dealer["standing"]:
		change_state(Game_State.RESULT)
		dealer_started = false
	else:
		dealer_turn()

func calculate_hand_value(hand):
	var value = 0
	var aces = []
	for card in hand:
		if card["rank"] == "Ace":
			aces.append(card)
		match card["rank"]:
			"Two": value += 2
			"Three": value += 3
			"Four": value += 4
			"Five": value += 5
			"Six": value += 6
			"Seven": value += 7
			"Eight": value += 8
			"Nine": value += 9
			"Ten", "Jack", "Queen", "King": value += 10
	var ace_value = 0
	var aces_left = aces.size()
	for ace in aces:
		if value + ace_value + aces_left > 10:
			ace_value += 1
		else:
			ace_value += 11
		aces_left -= 1
	value += ace_value
	return value 
		
func result():
	if player["bust"]:
		result_label.text = "Bust!\nYou Lose!"
		return
	if dealer["bust"]:
		result_label.text = "You Win!\nWinnings: " + str(player["bet"] * 2)
		return
	var player_hand_value = calculate_hand_value(player["hand"])
	var dealer_hand_value = calculate_hand_value(dealer["hand"])
	if player_hand_value == dealer_hand_value:
		result_label.text = "Draw!"
	elif player_hand_value > dealer_hand_value:
		result_label.text = "You Win!\nWinnings: " + str(player["bet"] * 2)
	elif dealer_hand_value > player_hand_value:
		result_label.text = "You Lose!"
	
func change_state(state):
	current_state = state

func _on_quit_button_pressed() -> void:
	GlobalSignal.unpause.emit()
	queue_free()
	
func _on_bet_button_pressed() -> void:
	player["bet"] = bet_value.value
	betting.visible = false
	change_state(Game_State.DEAL)

func _on_hit_button_pressed() -> void:
	if current_state == Game_State.PLAYER_TURN:
		var new_card = deck.draw_card()
		player["hand"].append(new_card)
		draw_card_sprite.emit(new_card, Role.PLAYER)
	
func _on_stand_button_pressed() -> void:
	player["standing"] = true
