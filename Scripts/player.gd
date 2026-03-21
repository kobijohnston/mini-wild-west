extends CharacterBody2D

enum Player_State { FREE, AIMING, PAUSED }
enum Tooltips { FREE, AIMING, PLAY_BLACKJACK, NEAR_SHOP }
var current_state = Player_State.FREE
var current_tooltip = Tooltips.FREE
var last_state = current_state
var last_tooltip = current_tooltip
var aiming_setup = false
var paused = false

var inventory_scene = preload("res://Scenes/Menus/Inventory/inventory.tscn")
var inventory = inventory_scene.instantiate()

var stats = {
	"health": 100,
	"money": 10,
	"ammo": 36,
	"inventory": [] 
}

var sprite_scaling = 4
@export var speed = 60 * sprite_scaling
@export var sprint_speed = speed * 1.5
@export var stamina_recharge_speed = 2
var character_direction : Vector2
const STAMINA = 300 #frames
var sprint_timer = STAMINA
var sprinting = false
var sprinting_set = false
var crosshair_scene = preload("res://Scenes/Weapons/crosshair.tscn")
var revolver_scene = preload("res://Scenes/Weapons/revolver.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var revolver = revolver_scene.instantiate()
@onready var current_weapon = revolver

func _ready():
	
	GlobalSignal.near_blackjack.connect(_on_near_blackjack)
	GlobalSignal.unpause.connect(_on_unpause)
	GlobalSignal.reload_finished.connect(_on_reload_finished)
	GlobalSignal.change_money.connect(_on_change_money)
	GlobalSignal.near_shop_desk.connect(_on_near_shop_desk)
	GlobalSignal.change_ammo.connect(_on_change_ammo)
	GlobalSignal.give_item.connect(_on_give_item)
	GlobalSignal.take_item.connect(_on_take_item)
	
func _physics_process(delta):

	match current_state:
		Player_State.FREE:
			movement()
		Player_State.AIMING:
			movement()
			aiming()
		Player_State.PAUSED:
			pass
	
	match current_tooltip:
		
		Tooltips.FREE:
			GlobalSignal.show_tooltip.emit("Free")
		Tooltips.AIMING:
			GlobalSignal.show_tooltip.emit("Aiming")
		Tooltips.PLAY_BLACKJACK:
			GlobalSignal.show_tooltip.emit("Play Blackjack")
		Tooltips.NEAR_SHOP:
			GlobalSignal.show_tooltip.emit("Enter Shop")

func movement():
	
	character_direction.x = Input.get_axis("left", "right")
	character_direction.y = Input.get_axis("up", "down")
	character_direction = character_direction.normalized()
	
	if character_direction:
		
		if Input.is_action_pressed("shift") and sprint_timer > 0:
			if sprinting:
				pass
			else:
				if sprint_timer >= 50:
					sprinting = true
		else:
			sprinting = false
		
		if sprinting:
			velocity = character_direction * sprint_speed
			sprint_timer -= 1
		else:
			velocity = character_direction * speed
		GlobalSignal.is_player_sprinting.emit(sprinting, sprint_timer)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		if sprint_timer < STAMINA:
			if STAMINA - sprint_timer >= stamina_recharge_speed:
				sprint_timer += stamina_recharge_speed
			else:
				sprint_timer = STAMINA
			GlobalSignal.is_player_sprinting.emit(sprinting, sprint_timer)
	
	if Input.is_action_pressed("interact"):
		interact()

	if current_state == Player_State.FREE and Input.is_action_just_pressed("shoot"):
		change_state(Player_State.AIMING)
	move_and_slide()

func aiming():
	
	if not aiming_setup:
		var weapon_added = false
		for child in get_children(): # checks to see if weapon is a child of the player yet, this can prob be done away with when weapon switching is a thing
			if not weapon_added and child == current_weapon:
				weapon_added = true
		if not weapon_added:
			add_child(current_weapon)
			weapon_added = true
		aiming_setup = true
		current_weapon.visible = true
	
	var aim_direction = (get_global_mouse_position() - global_position).normalized()
	current_weapon.global_position = marker_2d.global_position
	current_weapon.rotation = aim_direction.angle()
	
	var crosshair = crosshair_scene.instantiate()
	crosshair.global_position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("space"):
		change_state(Player_State.FREE)
		current_weapon.visible = false
		aiming_setup = false
	if Input.is_action_just_pressed("left click"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		current_weapon.reload(stats["ammo"])

func shoot():
	if current_weapon.ammo > 0:
		var mouse_pos = get_global_mouse_position()
		var aim_direction = (mouse_pos - global_position).normalized()
		current_weapon.shoot(global_position, aim_direction)
	else:
		current_weapon.reload(stats["ammo"])

func pause():
	last_state = current_state
	if not paused:
		current_state = Player_State.PAUSED
	
func interact():
	
	match current_tooltip:
		Tooltips.PLAY_BLACKJACK:
			
			var blackjack_scene = preload("res://Scenes/Mini Games/blackjack.tscn")
			var blackjack_game = blackjack_scene.instantiate()
			add_child(blackjack_game)
			blackjack_game.set_money(stats["money"])
			change_state(Player_State.PAUSED)
			
		Tooltips.NEAR_SHOP:
			
			var shop_scene = preload("res://Scenes/Menus/shop_menu.tscn")
			var shop_menu = shop_scene.instantiate()
			add_child(shop_menu)
			shop_menu.configure(stats)  
			change_state(Player_State.PAUSED)
			
		_: # Tooltips: FREE, AIMING
			
			if inventory.configured:
				inventory.visible = true
				change_state(Player_State.PAUSED)
			else:
				inventory.configure(stats["inventory"])
				add_child(inventory)
				inventory.visible = true
				change_state(Player_State.PAUSED)

	
func change_state(state):
	if state == Player_State.PAUSED:
		pause()
		return
	current_state = state
	match state:
		Player_State.FREE:
			current_tooltip = Tooltips.FREE
		Player_State.AIMING:
			current_tooltip = Tooltips.AIMING
	last_tooltip = current_tooltip
	
func _on_near_blackjack(is_near_blackjack):
	if is_near_blackjack:
		current_tooltip = Tooltips.PLAY_BLACKJACK
	else:
		current_tooltip = last_tooltip

func _on_near_shop_desk(shop, is_near_shop_desk):
	if is_near_shop_desk:
		current_tooltip = Tooltips.NEAR_SHOP
	else:
		current_tooltip = last_tooltip
		
func _on_unpause():
	print(last_state)
	change_state(last_state)

func _on_reload_finished(ammo):
	stats["ammo"] -= ammo
	GlobalSignal.player_ammo_changed.emit(stats["ammo"])

func _on_change_ammo(ammo):
	stats["ammo"] += ammo
	GlobalSignal.player_ammo_changed.emit(stats["ammo"])
	
func _on_change_money(change_by):
	stats["money"] += round_money(change_by)
	print(str(change_by))
	GlobalSignal.player_money_changed.emit(stats["money"])
	
func round_money(money) -> float:
	var rounded_money = snapped(money, 0.01)
	return rounded_money

func _on_give_item(item):
	
	for i in stats["inventory"]:
		print("Item in inventory: " + i["name"])
		
	stats["inventory"].append(item)
	print("------------------------")
	
	for i in stats["inventory"]:
		print("Item in inventory: " + i["name"])
	if not inventory.configured:
		
		add_child(inventory)
		inventory.configure(stats["inventory"])
		return
	
	inventory.populate_inventory(stats["inventory"])
	
func _on_take_item(item):
	
	var removed = false
	var index = 0
	for i in stats["inventory"]:
		if not removed:
			if i == item:
				stats["inventory"].remove_at(index)
			index += 1
			removed = true 
	
	inventory.populate_inventory(stats["inventory"])
