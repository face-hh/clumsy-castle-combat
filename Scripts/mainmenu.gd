extends Node2D

var other_player_id
var players_done = []
var hole_puncher
var game_code
const traversal_server_ip := 'localhost'
const traversal_server_port := 13000

signal exit_lobby
signal update_status(text)

func _ready():
	# warning-ignore:return_value_discarded
	#get_tree().connect('network_peer_connected', _player_connected)
	server_for_local_game()
	start_server()

func server_for_local_game():
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(4242, 2)

	var world = load("res://Scenes/level.tscn").instantiate()
	get_node('/root').add_child.call_deferred(world)

	var selfPeerID = peer.get_unique_id()

	emit_signal('exit_lobby')


func connect_to_server(code):
	game_code = code
	print('traversing nat...')
	
	var result = await (await traverse_nat(false)).completed
	
	print('nat traversed!')
	var host_address = result[2]
	var host_port = result[1]
	var own_port = result[0]
	print(['own port ', own_port])
	print(['host: ', host_address, ':', host_port])

	var peer = ENetMultiplayerPeer.new()
	peer.create_client(host_address, host_port, 0, 0, own_port)
	get_tree().set_network_peer(peer)


func start_server():
	print('traversing nat...')
	game_code = generate_game_code()
	var result = await (await traverse_nat(true)).completed
	print('nat traversed!')
	var my_port = result[0]
	print(['my port ', my_port])

	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(my_port, 1)
	if (err != OK):
		print(['could not create server: ', err])
		emit_signal('update_status', 'Failed to create game server')
	get_tree().set_network_peer(peer)

func reset():
	var tree = get_tree()
	if hole_puncher != null:
		if hole_puncher.is_host:
			hole_puncher.finalize_peers(game_code)
		# we shouldn't have to call this as the server normally
		# does this when we call finalize_peers,
		# but if our client is still registered in an old, lingering 
		# session, it won't get cleaned up without the following call
		hole_puncher.checkout()
		hole_puncher.queue_free()

	if tree.network_peer == null:
		return

	tree.network_peer.close_connection()
	tree.network_peer = null


func _player_connected(id):
	get_tree().refuse_new_network_connections = true
	other_player_id = id
	if get_tree().is_network_server():
		rpc('pre_configure_game')


func pre_configure_game():
	var selfPeerID = get_tree().get_network_unique_id()

	var world = load('res://Main.tscn').instance()

	var planet_name = \
		'planet_1' if get_tree().is_network_server() else 'planet_2'
	var my_planet = world.get_node(planet_name)
	my_planet.set_network_master(selfPeerID)

	var other_planet_name = \
		'planet_2' if get_tree().is_network_server() else 'planet_1'
	var other_planet = world.get_node(other_planet_name)
	other_planet.set_network_master(other_player_id)

	get_node('/root').add_child(world)

	rpc("done_preconfiguring", selfPeerID)
	get_tree().set_pause(true)


func done_preconfiguring(who):
	assert(not who in players_done)

	players_done.append(who)

	if players_done.size() == 2:
		rpc("post_configure_game")


func post_configure_game():
	emit_signal('exit_lobby')


func traverse_nat(is_host):
	hole_puncher = preload('res://addons/Holepunch/holepunch_node.gd').new()
	hole_puncher.rendevouz_address = traversal_server_ip
	hole_puncher.rendevouz_port = traversal_server_port
	add_child(hole_puncher)
	hole_puncher.connect('session_registered', _session_registered)
	var player_host = 'host' if is_host else 'client'
	var traversal_id = '%s_%s' % [OS.get_unique_id(), player_host]
	hole_puncher.start_traversal(game_code, is_host, traversal_id)
	print('awaiting for hole to be punched')
	hole_puncher.connect("hole_punched", func(x, y, z): print(x, y, z))
	print()
	await get_tree().create_timer(60).timeout
	
	return 3

func generate_game_code():
	# use a local randomized RNG to keep the global RNG reproducible
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var length = 4
	var result = ''
	for _n in range(length):
		var ascii = rng.randi_range(0, 25) + 65
		result += '%c' % ascii
	return result

func _session_registered():
	emit_signal('update_status', 'Game Code: %s\nWaiting for other player...' % game_code)

# remove ourselves from the holepunch server before exiting
func _notification(_what):
	if is_instance_valid(hole_puncher):
		hole_puncher.checkout()
		if hole_puncher.is_host:
			hole_puncher.finalize_peers(game_code)
