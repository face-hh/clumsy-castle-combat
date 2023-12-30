class_name Character

extends CharacterBody3D

@export var side: String # important
@export var timer: Timer

var speed: float = 2 * 2
var accel: int = 10

var intern: String
var card_name: String
var markers: Node3D

var damage: int
var tower_damage: int

var hitspeed: float

var total_health: float
var health: float

var deploy_time: float

var node: Node3D
var anim: AnimationPlayer

var stop_moving: bool = false

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var condition: bool = "Knight" in name or "Musk" in name or "Log" in name
@onready var res: CardType = Data.get_card(card_name)

var healthbar: HealthBar

func _ready() -> void:
	timer = $Timer
	var _catch: Error = get_parent().get_parent().connect("interaction_finished", t)

	$".".name = intern
	if has_node("HealthBar3D"):
		healthbar = ($HealthBar3D as HealthBar)
		healthbar.side = side
		healthbar.update_colors()

	node = $Models.get_node(side)
	anim = node.get_node("AnimationPlayer")

	node.visible = true
	anim.play("walk")

var entityNearby: CharacterBody3D
var closestMarkerPosition: Vector3 # Variable to store the relative position of the closest marker

func _process(delta: float) -> void:
	if res.type == DataType.TYPES.SPELL:
		move_type_spell(delta)
	elif res.type == DataType.TYPES.TROOP:
		move_type_troop(delta)

func move_type_troop(delta: float) -> void:
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
	if is_instance_valid(entityNearby):
		nav.target_position = entityNearby.global_position

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()

	velocity = velocity.lerp(direction * speed, accel * delta)
	look_at(nav.target_position, Vector3.UP)
	rotation.y = rotation.y - deg_to_rad(190)
	print(rotation.y)
	rotation.z = 0
	rotation.x = 0

	move_and_slide()

var move_speed: float = 5.0  # Adjust the speed as needed
var move_distance: float = 20.0  # Adjust the distance as needed
var elapsed_time: float = 0.0

func move_type_spell(delta: float) -> void:
	var z: float = move_speed * delta
	if side == "blue":
		z = -z

	var translation: Vector3 = Vector3(0, 0, z)
	translate(translation)

	# Update elapsed time
	elapsed_time += delta

	# Check if the determined distance is reached
	if elapsed_time >= move_distance / move_speed:
		queue_free()
func take_damage(taken_damage: int) -> void:
	health -= taken_damage
	($"HealthBar3D" as HealthBar).update_value((health / total_health) * 100, health)
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
	if body.get_parent().get_parent() is Tower:
		body = body.get_parent().get_parent()

	if (body is Tower or body is Character) and self != body:
		var self_spell: bool = res.type == DataType.TYPES.SPELL

		var game: Game = get_parent().get_parent() as Game

		if ("buildings" in res.target) and body is Character:
			return
		if !(side in body.name) and !self_spell:
			game.start_card_shoot(self, body)
		elif self_spell:
			game.card_deal_damage(self, body)

func _on_range_body_entered_MUSK(body: Node3D) -> void:
	ranged_troop_shoot(body)

func _on_vision_body_entered(body: Node3D) -> void:
	var opposite_side: String = "blue" if side == "red" else "red"

	if opposite_side in body.name and body is Character and !(body == self):
		entityNearby = body
	if "buildings" in res.target:
		entityNearby = null

func _on_vision_body_exited(body: Node3D) -> void:
	if body == entityNearby:
		entityNearby = null


func _on_knight_area_entered(body: Node3D) -> void:
	ranged_troop_shoot(body)


func _on_log_entered(body: Node3D) -> void:
	ranged_troop_shoot(body)
