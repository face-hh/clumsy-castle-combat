class_name Character

extends CharacterBody3D

@export var side: String # important
@export var timer: Timer

var speed: float = 2 * 2
var accel: int = 10

var intern: String
var markers: Node3D

var damage: int
var hitspeed: float

var total_health: float
var health: float

var deploy_time: float

var node: Node3D
var anim: AnimationPlayer

var stop_moving: bool = false

@onready var nav: NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	timer = $Timer
	var _catch: Error = get_parent().get_parent().connect("interaction_finished", t)

	$".".name = intern
	($HealthBar3D as HealthBar).side = side
	($HealthBar3D as HealthBar).update_colors()

	if "Knight" in name or "Musk" in name or "Log" in name:
		node = $Models.get_node(side)
		anim = node.get_node("AnimationPlayer")

		node.visible = true
		anim.play("walk")


var closestMarkerPosition: Vector3 # Variable to store the relative position of the closest marker

func _process(delta: float) -> void:
	if stop_moving:
		return
	var direction: Vector3 = Vector3()

	var closest_distance: float = 9999
	var closest_marker: Node = null

	for marker in markers.get_children():
		if !(side in marker.name):
			var distance: float = (marker as Marker3D).global_position.distance_to(global_position)
			if distance < closest_distance:
				closest_distance = distance
				closest_marker = marker

	if closest_marker:
		if closest_marker is Marker3D:
			nav.target_position = (closest_marker as Marker3D).global_position

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)

	look_at(nav.target_position, Vector3.UP)
	rotation.y = rotation.y - deg_to_rad(190)
	rotation.z = 0
	rotation.x = 0

	move_and_slide()

func take_damage(taken_damage: int) -> void:
	health -= taken_damage
	($"HealthBar3D" as HealthBar).update_value((health / total_health) * 100)
	if health <= 0:
		queue_free()

func attack() -> void:
	anim.stop()
	stop_moving = true
	anim.play("attack", -1, hitspeed)

func t(body: Node3D) -> void:
	stop_moving = false
	(body as Character).anim.play("walk")

func ranged_troop_shoot(body: Node3D) -> void:
	# P.S. when you implement combat between cards, this should account for Character too
	if body is Tower:
		var target: Node3D = (body as Tower).get_parent()

		if ("princess" in target.name or "king" in target.name) and !(side in target.name):
			(get_parent().get_parent() as Game).start_card_shoot(self, (target as Tower))

func _on_range_body_entered_MUSK(body: Node3D) -> void:
	ranged_troop_shoot(body)
