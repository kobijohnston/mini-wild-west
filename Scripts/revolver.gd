class_name Revolver
extends Node

@onready var marker_2d: Marker2D = $Marker2D

const MAX_AMMO = 6
const COOLDOWN_TIME = 60 
const RELOAD_TIME = 180
var reload_timer = RELOAD_TIME
var cooldown_timer = COOLDOWN_TIME
var ammo = MAX_AMMO
var ready_to_shoot = true
var reloading = false
var bullet_scene = preload("res://Scenes/Weapons/bullet.tscn")

func _process(delta: float):
	if not reloading:
		if not ready_to_shoot:
			if cooldown_timer == 0:
				cooldown_timer = COOLDOWN_TIME
				ready_to_shoot = true
				return
			cooldown_timer -= 1
	else:
		if reload_timer > 0:
			reload_timer -= 1
		else:
			reload_timer = RELOAD_TIME
			reloading = false

func shoot(position, rotation):
	if ready_to_shoot and not reloading:
		if ammo > 0:
			var bullet = bullet_scene.instantiate()
			bullet.position = marker_2d.global_position
			bullet.rotation = marker_2d.global_rotation
			bullet.shooter = get_parent()
			get_tree().current_scene.add_child(bullet)
			ammo -= 1
			GlobalSignal.ammo_changed.emit(-1)
			ready_to_shoot = false
		else:
			reload()

func reload():
	if ammo == MAX_AMMO:
		return  
	reloading = true
	ammo = MAX_AMMO
	GlobalSignal.reload.emit(Revolver)

func _on_ammo_changed():
	pass
