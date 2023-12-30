class_name HealthBar

extends Sprite3D

var side: String
var not_tower: bool = true
var max_value: float

var c1: Color = Color.hex(0xEF6050FF)
var c2: Color = Color.hex(0x0175E6FF)

@export var viewport: SubViewport

@onready var two_d_bar: TextureProgressBar = $"SubViewport/2d_hp_bar/2d_hp_bar"
@onready var label: Label = $"SubViewport/2d_hp_bar/Label"

func update_colors() -> void:
	texture = viewport.get_texture()

	if side == "red":
		two_d_bar.modulate = c1
	elif side == "blue":
		two_d_bar.modulate = c2

	if not_tower:
		label.visible = false
	if max_value:
		label.text = str(max_value)

func update_value(value: float, raw_value: float) -> void:
	two_d_bar.value = value
	if !not_tower:
		label.text = str(int(raw_value))
