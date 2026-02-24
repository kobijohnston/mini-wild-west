extends CanvasLayer

enum Shop_State { START, BUY, SELL}

var current_state = Shop_State.START
var last_state = current_state

@onready var buy_or_sell: Control = $"Buy Or Sell"
@onready var buy_menu: Control = $"Buy Menu"
@onready var sell_menu: Control = $"Sell Menu"

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	
	match current_state:
		Shop_State.START:
			start_screen()
		Shop_State.BUY:
			buy_screen()
		Shop_State.SELL:
			sell_screen()
			
func start_screen():
	buy_or_sell.visible = true

func buy_screen():
	buy_menu.visible = true

func sell_screen():
	sell_menu.visible = true
	
func change_state(state):
	last_state = current_state
	current_state = state
	
func _on_enter_buy_pressed() -> void:
	change_state(Shop_State.BUY)
	buy_or_sell.visible = false

func _on_enter_sell_pressed() -> void:
	change_state(Shop_State.SELL)
	buy_or_sell.visible = false

func _on_back_from_buy_pressed() -> void:
	change_state(Shop_State.START)
	buy_menu.visible = false

func _on_back_from_sell_pressed() -> void:
	change_state(Shop_State.START)
	sell_menu.visible = false
