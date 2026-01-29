extends Node

const MAX_AMMO = 6
const COOLDOWN_TIME = 60 
var cooldown_timer = COOLDOWN_TIME
var ammo = MAX_AMMO
var ready_to_shoot = true
var bullet_scene = preload("res://Scenes/Weapons/bullet.tscn")
func _process(delta: float):
	if not ready_to_shoot:
		if cooldown_timer == 0:
			cooldown_timer = COOLDOWN_TIME
			ready_to_shoot = true
			return
		cooldown_timer -= 1

func shoot(position, rotation):
	if ready_to_shoot:
		if ammo > 0:
			var bullet = bullet_scene.instantiate()
			bullet.position = position
			bullet.rotation = rotation.angle()
			get_tree().current_scene.add_child(bullet)
			ammo -= 1
			ready_to_shoot = false
