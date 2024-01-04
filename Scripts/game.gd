class_name Game

extends Node3D

# TOWER TROOP
@export var PRINCESS_RED_1: Tower
@export var PRINCESS_RED_2: Tower
@export var KING_RED: Tower

@export var PRINCESS_BLUE_1: Tower
@export var PRINCESS_BLUE_2: Tower
@export var KING_BLUE: Tower

# TOWER ITSELF
@export var T_PRINCESS_RED_1: Tower
@export var T_PRINCESS_RED_2: Tower
@export var T_KING_RED: Tower

@export var T_PRINCESS_BLUE_1: Tower
@export var T_PRINCESS_BLUE_2: Tower
@export var T_KING_BLUE: Tower

# MISC
@export var bullet: PackedScene

@export var Button1: Button
@export var Button2: Button
@export var Button3: Button
@export var Button4: Button
@export var Button5: Button
@export var Button6: Button
@export var Button7: Button
@export var Button8: Button

var active_towers: Array = []

var busy_towers: Array[Object] = []
var busy_characters: Array[Character] = []

signal interaction_finished

func _ready() -> void:
	(Data as DataType).reload_audio()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("spawn"):
		spawn_random_troop()

	for tower: Array in active_towers:
		if !is_instance_valid(tower[1]):
			return
		var t1: Node3D = tower[0]

		var node: Tower = t1 as Tower
		var target: Character = tower[1]

		if node.timer.get_signal_connection_list("timeout").size() <= 0:
			node.timer.connect("timeout", tower_shoot.bind(node, target))
			node.timer.start()

			var index: int = active_towers.find(tower)

			if index != -1:
				active_towers.remove_at(index)

func tower_shoot(node: Tower, target: Character) -> void:
	if !is_instance_valid(target):
		return

	var tower_troop: Node3D = troop(node)

	if !is_instance_valid(tower_troop) or !is_instance_valid(target) or target.res.type == DataType.TYPES.SPELL:
		return
	var anim: AnimationPlayer = tower_troop.get_node("AnimationPlayer")

	anim.play("KeyAction", -1, node.hitspeed * 2)

	var blt: Bullet = bullet.instantiate()

	add_child(blt)

	blt.damage = node.damage
	blt.global_position = Vector3(node.global_position.x, 4.185, node.global_position.z)
	blt.target = target

	tower_troop.look_at(target.global_position, Vector3.UP)
	tower_troop.rotation.y = tower_troop.rotation.y - deg_to_rad(95)
	tower_troop.rotation.z = 0
	tower_troop.rotation.x = 0

func troop(node: Node3D) -> Node3D:
	var n: String = str(node.name)

	if $Troops.has_node(n):
		return $Troops.get_node(n)
	else:
		return null

func start_shoot(target: Node3D, node: Tower) -> void:
	if !is_instance_valid(node):
		stop_shoot(node, target as Tower)
		return
	if ("red" in target.name and "red" in node.name) or ("blue" in target.name and "blue" in node.name) or not ("enemy" in target.name) or (target as Character).res.type == DataType.TYPES.SPELL:
		return

	var connections: int = node.timer.get_signal_connection_list("timeout").size()
	if connections > 0:
		active_towers.append([node, target])
		return

	node.timer.connect("timeout", tower_shoot.bind(node, target))
	node.timer.start()

func stop_shoot(target: Node3D, node: Node3D) -> void:
	if node is Tower:
		var tower: Tower = node as Tower
		# prevent crashing when closed
		if !is_instance_valid(tower) or !is_instance_valid(troop(tower)):
			return
		if !is_instance_valid(tower.timer):
			return

		if ("red" in target.name and "red" in tower.name) or ("blue" in target.name and "blue" in tower.name) or not ("enemy" in target.name) or (target as Character).res.type == DataType.TYPES.SPELL:
			return

		troop(node).rotation.y = deg_to_rad(90)

		if tower.timer.is_connected("timeout", tower_shoot):
			tower.timer.disconnect("timeout", tower_shoot)
			tower.timer.stop()

func button_pressed(button: Button) -> void:
	spawn_card(button.text)

func spawn_card(card_name: String, side: String = "blue", spawn_position: Vector3 = Vector3(0, 1, 6)) -> void:
	var card: CardType = Data.get_card(card_name)

	var card_scene: Character = card.scene.instantiate();

	card_scene.side = side
	card_scene.name = side + "_enemy_" + card_scene.name
	card_scene.intern = side + "_enemy_" + card_scene.name
	card_scene.card_name = card.card_name

	get_node("SpawnedCards").add_child(card_scene)

	card_scene.total_health = card.health
	card_scene.health = card.health
	card_scene.damage = card.damage
	card_scene.tower_damage = card.tower_damage
	# /40 HERE, REMOVED SINCE IN DEV
	card_scene.speed = card.speed / 25 # transform to GoDot speed
	card_scene.hitspeed = card.hitspeed
	card_scene.deploy_time = card.deploy_time
	card_scene.position = spawn_position
	card_scene.timer.wait_time = card.hitspeed
	card_scene.markers = $Markers

func start_card_shoot(body: Node3D, target: Object) -> void:
	if body is Character:
		var body_char: Character = body as Character

		if "enemy" in body.name:
			if body_char.timer.is_connected("timeout", card_deal_damage):
				return
			if target is Tower:
				if (target as Tower).getting_destroyed:
					return

			card_deal_damage(body_char, target)

			busy_towers.append(target)
			busy_characters.append(body)

			body_char.timer.connect("timeout", card_deal_damage.bind(body_char, target))
			body_char.timer.start()

func card_deal_damage(body: Character, target: Object) -> void:
	var spell: bool = body.res.type == DataType.TYPES.SPELL

	if target is Character:
		var t: Character = (target as Character)

		t.health -= body.damage
		t.healthbar.update_value((t.health / t.total_health) * 100, t.health)

	if target is Tower:
		var t: Tower = (target as Tower)
		t.health -= body.tower_damage
		t.healthbar.update_value((t.health / t.total_health) * 100, t.health)

	if !spell:
		body.attack() # plays anim
	if !is_instance_valid(target):
		return

	if ((target as Tower).health if target is Tower else (target as Character).health) <= 0:
		active_towers = []
		if target is Tower:
			(target as Tower).play_death()

		for i in busy_towers.size():
			var character: Character = busy_characters[i]
			var twr: Object = busy_towers[i]

			if !is_instance_valid(character) or !is_instance_valid(twr):
				continue # cached dead characters

			_dead_target(character, twr)

		busy_towers = []
		busy_characters = []

func _dead_target(body: Character, target: Object) -> void:

	interaction_finished.emit(body)

	if target is Tower:
		if is_instance_valid(troop((target as Tower))):
			troop((target as Tower)).queue_free()
	if target is Character:
		(target as Character).queue_free()

	body.timer.disconnect("timeout", card_deal_damage.bind(body, target))

func _on_princess_red_1_body_entered(body: Node3D) -> void:
	start_shoot(body, T_PRINCESS_RED_1)


func _on_princess_red_2_body_entered(body: Node3D) -> void:
	start_shoot(body, T_PRINCESS_RED_2)


func _on_king_red_body_entered(body: Node3D) -> void:
	start_shoot(body, T_KING_RED)


func _on_princess_blue_1_body_entered(body: Node3D) -> void:
	start_shoot(body, T_PRINCESS_BLUE_1)


func _on_princess_blue_2_body_entered(body: Node3D) -> void:
	start_shoot(body, T_PRINCESS_BLUE_2)


func _on_king_blue_body_entered(body: Node3D) -> void:
	start_shoot(body, T_KING_BLUE)


func _on_princess_red_1_body_exited(body: Node3D) -> void:
	stop_shoot(body, T_PRINCESS_RED_1)


func _on_princess_red_2_body_exited(body: Node3D) -> void:
	stop_shoot(body, T_PRINCESS_RED_2)


func _on_king_red_body_exited(body: Node3D) -> void:
	stop_shoot(body, T_KING_RED)


func _on_princess_blue_1_body_exited(body: Node3D) -> void:
	if is_instance_valid(PRINCESS_BLUE_1):
		stop_shoot(body, PRINCESS_BLUE_1)


func _on_princess_blue_2_body_exited(body: Node3D) -> void:
	if is_instance_valid(PRINCESS_BLUE_2):
		stop_shoot(body, PRINCESS_BLUE_2)


func _on_king_blue_body_exited(body: Node3D) -> void:
	if is_instance_valid(KING_RED):
		stop_shoot(body, KING_RED)


func _on_button_pressed() -> void:
	button_pressed(Button1)


func _on_button_2_pressed() -> void:
	button_pressed(Button2)


func _on_button_3_pressed() -> void:
	button_pressed(Button3)


func _on_button_4_pressed() -> void:
	button_pressed(Button4)

func _on_button_5_pressed() -> void:
	button_pressed(Button5)

func _on_button_6_pressed() -> void:
	button_pressed(Button6)

func _on_button_7_pressed() -> void:
	button_pressed(Button7)

func _on_button_8_pressed() -> void:
	button_pressed(Button8)

func _on_tower_body_entered_princess_red_1(body: Node3D) -> void:
	start_card_shoot(body as Character, T_PRINCESS_RED_1)


func _on_tower_body_entered_princess_red_2(body: Node3D) -> void:
	start_card_shoot(body as Character, T_PRINCESS_RED_2)


func _on_tower_body_entered_princess_blue_1(body: Node3D) -> void:
	start_card_shoot(body as Character, T_PRINCESS_BLUE_1)


func _on_tower_body_entered_princess_blue_2(body: Node3D) -> void:
	start_card_shoot(body as Character, T_PRINCESS_BLUE_2)


func _on_tower_body_entered_king_blue(body: Node3D) -> void:
	start_card_shoot(body as Character, T_KING_BLUE)


func _on_tower_body_entered_king_red(body: Node3D) -> void:
	start_card_shoot(body as Character, T_KING_RED)


func spawn_random_troop() -> void:
	var card: CardType = Data.cards.pick_random()
	var spawns: Array[Vector3] = [
		Vector3(-8, 2, -2.4),
		Vector3(-2, 2, -11.40),
		Vector3(8, 2, -11.40),
	]
	var spawn: Vector3 = spawns.pick_random()
	spawn_card(card.card_name, "red", spawn)



func _on_emote() -> void:
	($CanvasLayer/AnimatedSprite2D as AnimatedSprite2D).play("heheheha")
	($SFX/Misc/Heheheha as AudioStreamPlayer).play()


func _on_audio_stream_player_finished() -> void:
	($SFX/Misc/AudioStreamPlayer as AudioStreamPlayer).play()
