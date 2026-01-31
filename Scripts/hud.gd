extends CanvasLayer

@onready var revolver_barrell: AnimatedSprite2D = $"Control/Revolver Barrell"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.ammo_changed.connect(_on_ammo_changed)
	GlobalSignal.reload.connect(_on_reload)
func _process(delta: float) -> void:
	pass

func _on_ammo_changed(ammo):
	revolver_barrell.frame += ( -1 * ammo)

func _on_reload(weapon):
	revolver_barrell.animation = "reload"
	revolver_barrell.play()
	await revolver_barrell.animation_finished
	revolver_barrell.animation = "default"
