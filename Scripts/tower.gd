class_name Tower

extends Node3D

var health: float
var total_health: float
var damage: int
var hitspeed: float # seconds

var getting_destroyed: bool = false
var healthbar: HealthBar
var timer: Timer

func _ready() -> void:
	if "princess" in name:
		health = 4424
		total_health = 4424
		damage = 158
		hitspeed = 0.8
	elif "king" in name:
		health = 7032
		total_health = 7032
		damage = 158
		hitspeed = 1

	# This is in here because the Tower Troops and Towers share the same scripts.
	if get_parent().name == "Towers":
		healthbar = get_node("HealthBar3D") as HealthBar

		healthbar.side = name.split("_")[1]
		healthbar.not_tower = false
		healthbar.max_value = total_health
		healthbar.update_colors()

		timer = get_node("Timer")
		timer.wait_time = hitspeed

func play_death() -> void:
	getting_destroyed = true
	$"../../Areas".get_node(str(name)).queue_free()

	queue_free()
	$"../../Markers".get_node(str(name)).queue_free()
