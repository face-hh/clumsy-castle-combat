class_name HealthBar

extends Sprite3D

var side: String

var c1: Color = Color.hex(0xEF6050FF)
var c2: Color = Color.hex(0x0175E6FF)

@export var viewport: SubViewport
@export var hpbar: TextureProgressBar

func update_colors() -> void:
	texture = viewport.get_texture()

	#print("Applying color " + side + " for name " + get_parent().name + " color: " + str(c1.to_html()) + " c2: " + str(c2))
	if side == "red":
		modulate = c1
	elif side == "blue":
		modulate = c2

func update_value(value: float) -> void:
	hpbar.value = value
