extends CanvasLayer

@onready var revolver_barrell: AnimatedSprite2D = $"Control/Revolver Barrell"
@onready var tooltip_label: Label = $"Control/Tooltip"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignal.ammo_changed.connect(_on_ammo_changed)
	GlobalSignal.reload.connect(_on_reload)
	GlobalSignal.show_tooltip.connect(_on_show_tooltip)

func _on_ammo_changed(ammo):
	revolver_barrell.frame += ( -1 * ammo)

func _on_reload(weapon):
	revolver_barrell.animation = "reload"
	revolver_barrell.play()
	await revolver_barrell.animation_finished
	revolver_barrell.animation = "default"
	GlobalSignal.reload_finished.emit()
	
func _on_show_tooltip(tooltip):
	match tooltip:
		"Free":
			tooltip_label.text = "Left click to draw weapon"
		"Aiming":
			tooltip_label.text = "[ Space ] Holster weapon"
		"Play Blackjack":
			tooltip_label.text = "[ Q ] Play Blackjack"
