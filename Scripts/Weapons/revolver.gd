class_name Revolver
extends Node

@onready var marker_2d: Marker2D = $Marker2D

const MAX_AMMO = 6
const COOLDOWN_TIME = 60 
var cooldown_timer = COOLDOWN_TIME
var ammo = MAX_AMMO
var ready_to_shoot = true
var reloading = false
var bullet_scene = preload("res://Scenes/Weapons/bullet.tscn")

func _ready():
	GlobalSignal.reload_finished.connect(_on_reload_finished)
	
func _process(delta: float):
	if not reloading:
		if not ready_to_shoot:
			if cooldown_timer == 0:
				cooldown_timer = COOLDOWN_TIME
				ready_to_shoot = true
				return
			cooldown_timer -= 1

func shoot(position, rotation):
	if ready_to_shoot and not reloading:
		var bullet = bullet_scene.instantiate()
		bullet.position = marker_2d.global_position
		bullet.rotation = marker_2d.global_rotation
		bullet.shooter = get_parent()
		get_tree().current_scene.add_child(bullet)
		ammo -= 1
		GlobalSignal.ammo_changed.emit(-1)
		ready_to_shoot = false

func reload(player_ammo):
	if ammo == MAX_AMMO:
		return
	if player_ammo == 0:
		return
	else:
		if ammo == 0:
			if player_ammo >= MAX_AMMO:
				reloading = true
				ammo = MAX_AMMO
				GlobalSignal.reload.emit(Revolver, MAX_AMMO)
			elif player_ammo < MAX_AMMO:
				reloading = true
				ammo = player_ammo
				GlobalSignal.reload.emit(Revolver, player_ammo)
		else:
			var ammo_to_reload = MAX_AMMO - ammo
			if player_ammo >= ammo_to_reload:
				reloading = true
				ammo += ammo_to_reload
				GlobalSignal.reload.emit(Revolver, ammo_to_reload)
			if ammo_to_reload > player_ammo:
				reloading = true
				ammo = player_ammo
				GlobalSignal.reload.emit(Revolver, player_ammo)

func _on_reload_finished(ammo):
	reloading = false
