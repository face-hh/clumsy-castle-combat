class_name Tower

extends Node3D

var health: float
var total_health: float
var damage: int
var hitspeed: float # seconds

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
		healthbar.update_colors()

		timer = get_node("Timer")
		timer.wait_time = hitspeed

func play_death() -> void:
	var particles: GPUParticles3D = get_node("GPUParticles3D")
	particles.emitting = true
	var time: float = (particles.lifetime * 2) / particles.speed_scale

	get_tree().create_timer(time).connect("timeout", death)

func death() -> void:
	queue_free()
	$"../../Markers".get_node(str(name)).queue_free()
