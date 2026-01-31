extends CharacterBody2D

enum Player_State { FREE, AIMING }
var current_state = Player_State.FREE
var aiming_setup = false

@export var speed = 80
var character_direction : Vector2

@onready var marker_2d: Marker2D = $Marker2D

var crosshair_scene = preload("res://Scenes/Weapons/crosshair.tscn")
var revolver_scene = preload("res://Scenes/Weapons/revolver.tscn")
@onready var revolver = revolver_scene.instantiate()
@onready var current_weapon = revolver

func _physics_process(delta):

	match current_state:
		Player_State.FREE:
			movement()
		Player_State.AIMING:
			movement()
			aiming()

func movement():
	character_direction.x = Input.get_axis("left", "right")
	character_direction.y = Input.get_axis("up", "down")
	character_direction = character_direction.normalized()
	if character_direction:
		velocity = character_direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	if current_state == Player_State.FREE and Input.is_action_just_pressed("shoot"):
		current_state = Player_State.AIMING
		print("Weapon Drawn")
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
	
	var aim_direction = (get_global_mouse_position() - global_position).normalized()
	current_weapon.global_position = marker_2d.global_position
	current_weapon.rotation = aim_direction.angle()
	var crosshair = crosshair_scene.instantiate()
	crosshair.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("space"):
		current_state = Player_State.FREE
		aiming_setup = false
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		current_weapon.reload()

func shoot():
	var mouse_pos = get_global_mouse_position()
	var aim_direction = (mouse_pos - global_position).normalized()
	current_weapon.shoot(global_position, aim_direction)
