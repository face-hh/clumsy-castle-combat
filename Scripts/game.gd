extends Node3D

# TOWER TROOP
@export var PRINCESS_RED_1: Node3D
@export var PRINCESS_RED_2: Node3D
@export var KING_RED: Node3D

@export var PRINCESS_BLUE_1: Node3D
@export var PRINCESS_BLUE_2: Node3D
@export var KING_BLUE: Node3D

# TOWER ITSELF
@export var T_PRINCESS_RED_1: Node3D
@export var T_PRINCESS_RED_2: Node3D
@export var T_KING_RED: Node3D

@export var T_PRINCESS_BLUE_1: Node3D
@export var T_PRINCESS_BLUE_2: Node3D
@export var T_KING_BLUE: Node3D

# MISC
@export var bullet: PackedScene

@export var Button1: Button
@export var Button2: Button
@export var Button3: Button
@export var Button4: Button

var active_towers = []
var peers = []
var s_peer

signal interaction_finished

func create_player(id):
	setup_deck()
	peers.append(id)
	s_peer = id
	# Instantiate a new player for this client.
	print('player joined ', id)

func destroy_player(id):
	print('player left ', id)

func setup_deck():
	pass

func _process(delta) -> void:
	for tower in active_towers:
		var node = tower[0]
		var target = tower[1]

		if node.timer.get_signal_connection_list("timeout").size() <= 0:
			node.timer.connect("timeout", tower_shoot.bind(node, target))
			node.timer.start()

			var index = active_towers.find(tower)

			if index != -1:
				active_towers.remove_at(index)

func tower_shoot(node, target):
	var tower_troop = troop(node)
	if !is_instance_valid(tower_troop) or !is_instance_valid(target):
		return
	var anim: AnimationPlayer = tower_troop.get_node("AnimationPlayer")

	if anim.is_playing():
		return

	anim.play("KeyAction")

	var blt = bullet.instantiate()

	add_child(blt)

	blt.damage = node.damage
	blt.global_position = Vector3(node.global_position.x, 4.185, node.global_position.z)
	blt.target = target

	tower_troop.look_at(target.global_position, Vector3.UP)
	tower_troop.rotation.y = tower_troop.rotation.y - deg_to_rad(95)
	tower_troop.rotation.z = 0
	tower_troop.rotation.x = 0

func troop(node):
	return $Troops.get_node(str(node.name))

func start_shoot(target, node):
	if !is_instance_valid(node):
		return
	if ("red" in target.name and "red" in node.name) or ("blue" in target.name and "blue" in node.name) or not ("enemy" in target.name):
		return

	var connections = node.timer.get_signal_connection_list("timeout").size()
	if connections > 0:
		active_towers.append([node, target])
		return

	node.timer.connect("timeout", tower_shoot.bind(node, target))
	node.timer.start()

func stop_shoot(target, node):
	# prevent crashing when closed
	if !is_instance_valid(node) or !is_instance_valid(troop(node)):
		return
	if !is_instance_valid(node.timer):
		return

	if ("red" in target.name and "red" in node.name) or ("blue" in target.name and "blue" in node.name) or not ("enemy" in target.name):
		return

	troop(node).rotation.y = deg_to_rad(90)

	node.timer.disconnect("timeout", tower_shoot)
	node.timer.stop()

func button_pressed(button):
	var card = Data.cards.filter(func(el):
		return el.name == button.text)[0]

	var card_scene = card.scene.instantiate();

	card_scene.side = "blue" # CHANGE LATER (when adding multiplayer)
	card_scene.name = "blue_enemy_" + card_scene.name
	card_scene.intern = "blue_enemy_" + card_scene.name
	card_scene.total_health = card.health
	card_scene.health = card.health
	card_scene.damage = card.damage
	# /40 HERE, REMOVED SINCE IN DEV
	card_scene.speed = card.speed / 20 # transform to GoDot speed
	card_scene.hitspeed = card.hitspeed
	card_scene.deploy_time = card.deploy_time
	card_scene.position = Vector3(7, 1, 6)
	card_scene.timer.wait_time = card.hitspeed
	card_scene.markers = $Markers

	get_node("SpawnedCards").add_child(card_scene)

func start_card_shoot(body, target):
	if "enemy" in body.name:
		card_deal_damage(body, target)
		body.timer.connect("timeout", func (): card_deal_damage(body, target))
		body.timer.start()

func card_deal_damage(body, target):
	if !is_instance_valid(target):
		interaction_finished.emit(body)
		return

	target.health -= body.damage
	target.healthbar.update_value((target.health / target.total_health) * 100)
	body.attack() # plays anim

	if target.health <= 0:
		interaction_finished.emit(body)
		#print('emitted')
		if is_instance_valid(troop(target)):
			troop(target).queue_free()
			active_towers = []
			target.play_death()

func _on_princess_red_1_body_entered(body):
	start_shoot(body, T_PRINCESS_RED_1)


func _on_princess_red_2_body_entered(body):
	start_shoot(body, T_PRINCESS_RED_2)


func _on_king_red_body_entered(body):
	start_shoot(body, T_KING_RED)


func _on_princess_blue_1_body_entered(body):
	start_shoot(body, T_PRINCESS_BLUE_1)


func _on_princess_blue_2_body_entered(body):
	start_shoot(body, T_PRINCESS_BLUE_2)


func _on_king_blue_body_entered(body):
	start_shoot(body, T_PRINCESS_BLUE_2)


func _on_princess_red_1_body_exited(body):
	stop_shoot(body, T_PRINCESS_RED_1)


func _on_princess_red_2_body_exited(body):
	stop_shoot(body, T_PRINCESS_RED_2)


func _on_king_red_body_exited(body):
	stop_shoot(body, T_KING_RED)


func _on_princess_blue_1_body_exited(body):
	stop_shoot(body, PRINCESS_BLUE_1)


func _on_princess_blue_2_body_exited(body):
	stop_shoot(body, PRINCESS_BLUE_2)


func _on_king_blue_body_exited(body):
	stop_shoot(body, KING_RED)


func _on_button_pressed():
	button_pressed(Button1)


func _on_button_2_pressed():
	button_pressed(Button2)


func _on_button_3_pressed():
	button_pressed(Button3)


func _on_button_4_pressed():
	button_pressed(Button4)


func _on_tower_body_entered_princess_red_1(body):
	start_card_shoot(body, T_PRINCESS_RED_1)


func _on_tower_body_entered_princess_red_2(body):
	start_card_shoot(body, T_PRINCESS_RED_2)


func _on_tower_body_entered_princess_blue_1(body):
	start_card_shoot(body, T_PRINCESS_BLUE_1)


func _on_tower_body_entered_princess_blue_2(body):
	start_card_shoot(body, T_PRINCESS_BLUE_2)


func _on_tower_body_entered_king_blue(body):
	start_card_shoot(body, T_KING_BLUE)


func _on_tower_body_entered_king_red(body):
	start_card_shoot(body, T_KING_RED)
