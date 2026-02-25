class_name Deck
extends Node2D

@onready var cards: AnimatedSprite2D = $Cards

var ranks = ["Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Jack", "Queen", "King", "Ace"]
var suits = ["Hearts", "Diamonds", "Spades", "Clubs"]
var deck = []

func create_deck():
	for suit in suits:
		for rank in ranks:
			var card = {
				"suit": suit,
				"rank": rank,
				"face down": false,
				"sprite": 0
			}
			deck.append(card)
		
	for card in deck:
		card["sprite"] = get_card_sprite(card)

func draw_card():
	if deck.is_empty():
		print("ERROR: DECK EMPTY")
	var card = deck[0]
	deck.remove_at(0)
	return card

func get_card_sprite(card):
	if card["face down"]:
		return 0
	var rank = 0
	var rank_found = false
	for r in ranks:
		if not rank_found:
			rank += 1
			if r == card["rank"]:
				rank_found = true
	var suit = -1
	var suit_found = false
	for s in suits:
		if not suit_found:
			suit += 1
			if s == card["suit"]:
				suit_found = true
	return (13 * suit) + rank
