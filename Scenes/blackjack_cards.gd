extends Control
@onready var deck: AnimatedSprite2D = $Deck
@onready var dealer_marker: Marker2D = $"Dealer Marker"
@onready var player_marker: Marker2D = $"Player Marker"

var dealer_hand = []
var player_hand = []

var card_drawn = false
var face_down_card

func _on_blackjack_draw_card_sprite(card: Variant, role: Variant) -> void:
	var card_sprite = deck.sprite_frames.get_frame_texture("default", card["sprite"])
	if card["face down"]:
		card_sprite = deck.sprite_frames.get_frame_texture("default", 0)
	if role == 0: #Player
		player_hand.append(card_sprite)
	if role == 1: #Dealer
		if dealer_hand.size() == 1:
			face_down_card = card
		dealer_hand.append(card_sprite)
		
	card_drawn = true
	
func _process(delta: float) -> void:
	
	if card_drawn:
		draw_player_hand()
		draw_dealer_hand()
		card_drawn = false
	
func draw_player_hand():
	var player_position = player_marker.position
	for card in player_hand:
		var card_sprite = Sprite2D.new()
		card_sprite.add_to_group("Blackjack Cards")
		card_sprite.centered = false
		card_sprite.texture = card
		add_child(card_sprite)
		card_sprite.position = player_position
		player_position.x += 64

func draw_dealer_hand():
	var dealer_position = dealer_marker.position
	for card in dealer_hand:
		var card_sprite = Sprite2D.new()
		card_sprite.add_to_group("Blackjack Cards")
		card_sprite.centered = false
		card_sprite.texture = card
		add_child(card_sprite)
		card_sprite.position = dealer_position
		dealer_position.x += 64

func _on_blackjack_dealer_started_signal() -> void:
	dealer_hand[1] = deck.sprite_frames.get_frame_texture("default", face_down_card["sprite"])
	card_drawn = true
	
func _on_blackjack_new_game() -> void:
	for child in get_children():
		if child.is_in_group("Blackjack Cards"):
			child.queue_free()
	dealer_hand.clear()
	player_hand.clear()
