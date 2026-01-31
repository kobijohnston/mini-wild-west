extends CanvasLayer

@onready var revolver_barrell: AnimatedSprite2D = $"Control/Revolver Barrell"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.ammo_changed.connect(_on_ammo_changed)

func _process(delta: float) -> void:
	pass

func _on_ammo_changed(ammo, max_ammo):
	revolver_barrell.frame += ( -1 * ammo)
