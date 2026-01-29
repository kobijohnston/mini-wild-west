extends CharacterBody2D

enum Player_State { FREE, AIMING }
var current_state = Player_State.FREE
var crosshair_scene = preload("res://Scenes/Weapons/crosshair.tscn")
@export var speed = 60
var character_direction : Vector2

@onready var revolver: Node = $revolver
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
	var crosshair = crosshair_scene.instantiate()
	crosshair.global_position = get_global_mouse_position()
	if Input.is_action_just_pressed("space"):
		current_state = Player_State.FREE
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
func shoot():
	var mouse_pos = get_global_mouse_position()
	var aim_direction = (mouse_pos - global_position).normalized()
	current_weapon.shoot(global_position, aim_direction)
