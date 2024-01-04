class_name DataType

extends Node

enum RARITIES {COMMON, RARE, EPIC, LEGENDARY, CHAMPION}
enum TYPES {SPELL, TROOP, BUILDING}
# SPEEDS
# 60 - Medium

# DEPLOY TIME
# seconds.

# shut the fuck up
# gdscript doesnt support nested arrays
var paths: Array[String] = [
	"/root/GAME/SFX/Deploy/Knight", # 0
	"/root/GAME/SFX/Deploy/Musk", # 1
	"/root/GAME/SFX/Deploy/Log", # 2
	"/root/GAME/SFX/Deploy/MiniPekka", # 3
	"/root/GAME/SFX/Deploy/RoyalGiant", # 4
	"/root/GAME/SFX/Deploy/DartGoblin", # 5
	"/root/GAME/SFX/Deploy/Pekka", # 6
	"/root/GAME/SFX/Deploy/Dumb", # 7
	"/root/GAME/SFX/Attack/Knight_1", # 8
	"/root/GAME/SFX/Attack/Knight_2", # 9
	"/root/GAME/SFX/Attack/Knight_3", # 10
	"/root/GAME/SFX/Attack/Knight_4", # 11
	"/root/GAME/SFX/Attack/Knight_5", # 12
	"/root/GAME/SFX/Attack/Musk_1", # 13
	"/root/GAME/SFX/Attack/MiniPekka_1", # 14
	"/root/GAME/SFX/Attack/RoyalGiant_1", # 15
	"/root/GAME/SFX/Attack/RoyalGiant_2", # 16
	"/root/GAME/SFX/Attack/RoyalGiant_3", # 17
	"/root/GAME/SFX/Attack/DartGoblin_1", # 18
	"/root/GAME/SFX/Attack/DartGoblin_2", # 19
	"/root/GAME/SFX/Attack/Pekka_1", # 20
	"/root/GAME/SFX/Attack/Dumb_1", # 21
	"/root/GAME/SFX/Attack/Dumb_2", # 22
	"/root/GAME/SFX/Death/Knight", # 23
	"/root/GAME/SFX/Death/Musk", # 24
	"/root/GAME/SFX/Death/Log",# 25
	"/root/GAME/SFX/Death/MiniPekka", # 26
	"/root/GAME/SFX/Death/RoyalGiant", # 27
	"/root/GAME/SFX/Death/DartGoblin", # 28
	"/root/GAME/SFX/Death/Pekka", # 29
	"/root/GAME/SFX/Death/Dumb" # 30
]

var Knight: CardType = CardType.new()
var Musk: CardType = CardType.new()
var Log: CardType = CardType.new()
var MiniPekka: CardType = CardType.new()
var RoyalGiant: CardType = CardType.new()
var DartGoblin: CardType = CardType.new()
var Pekka: CardType = CardType.new()
var Dumb: CardType = CardType.new()

func _ready() -> void:
	Knight.card_name = "Knight"
	Knight.health = 2566
	Knight.damage = 293
	Knight.tower_damage = Knight.damage
	Knight.elixir = 3
	Knight.hitspeed = 1.2
	Knight.speed = 60
	Knight.deploy_time = 1
	Knight.target = ["ground"]
	Knight.transport = "ground"
	Knight.type = TYPES.TROOP
	Knight.rarity = RARITIES.COMMON
	Knight.scene = preload("res://Scenes/Cards/Knight.tscn")
	Knight.t_audio_deploy = [0]
	Knight.t_audio_attack = [8, 9, 10, 11, 12]
	Knight.t_audio_death = [23]

	Musk.card_name = "Musk"
	Musk.health = 1050
	Musk.damage = 318
	Musk.tower_damage = Musk.damage
	Musk.elixir = 4
	Musk.hitspeed = 1
	Musk.speed = 60
	Musk.deploy_time = 1
	Musk.target = ["air", "ground"]
	Musk.transport = "ground"
	Musk.type = TYPES.TROOP
	Musk.rarity = RARITIES.RARE
	Musk.scene = preload("res://Scenes/Cards/Musk.tscn")
	Musk.t_audio_deploy = [1]
	Musk.t_audio_attack = [13]
	Musk.t_audio_death = [24]

	Log.card_name = "Log"
	Log.health = 0
	Log.damage = 422
	Log.tower_damage = 84
	Log.elixir = 4
	Log.hitspeed = 1
	Log.speed = 60
	Log.deploy_time = 1
	Log.target = ["ground"]
	Log.transport = "ground"
	Log.type = TYPES.SPELL
	Log.rarity = RARITIES.LEGENDARY
	Log.scene = preload("res://Scenes/Cards/Log.tscn")
	Log.t_audio_deploy = [2]
	Log.t_audio_attack = []
	Log.t_audio_death = [25]

	MiniPekka.card_name = "MiniPekka"
	MiniPekka.health = 1983
	MiniPekka.damage = 1050
	MiniPekka.tower_damage = 1050
	MiniPekka.elixir = 4
	MiniPekka.hitspeed = 1.6
	MiniPekka.speed = 90
	MiniPekka.deploy_time = 1
	MiniPekka.target = ["ground"]
	MiniPekka.transport = "ground"
	MiniPekka.type = TYPES.TROOP
	MiniPekka.rarity = RARITIES.RARE
	MiniPekka.scene = preload("res://Scenes/Cards/MiniPekka.tscn")
	MiniPekka.t_audio_deploy = [3]
	MiniPekka.t_audio_attack = [14]
	MiniPekka.t_audio_death = [26]

	RoyalGiant.card_name = "RoyalGiant"
	RoyalGiant.health = 4464
	RoyalGiant.damage = 446
	RoyalGiant.tower_damage = 446
	RoyalGiant.elixir = 6
	RoyalGiant.hitspeed = 1.7
	RoyalGiant.speed = 45
	RoyalGiant.deploy_time = 1
	RoyalGiant.target = ["buildings"]
	RoyalGiant.transport = "ground"
	RoyalGiant.type = TYPES.TROOP
	RoyalGiant.rarity = RARITIES.COMMON
	RoyalGiant.scene = preload("res://Scenes/Cards/RoyalGiant.tscn")
	RoyalGiant.t_audio_deploy = [4]
	RoyalGiant.t_audio_attack = [15, 16, 17]
	RoyalGiant.t_audio_death = [27]

	DartGoblin.card_name = "DartGoblin"
	DartGoblin.health = 380
	DartGoblin.damage = 191
	DartGoblin.tower_damage = 191
	DartGoblin.elixir = 3
	DartGoblin.hitspeed = 0.7
	DartGoblin.speed = 120
	DartGoblin.deploy_time = 1
	DartGoblin.target = ["air", "ground"]
	DartGoblin.transport = "ground"
	DartGoblin.type = TYPES.TROOP
	DartGoblin.rarity = RARITIES.RARE
	DartGoblin.scene = preload("res://Scenes/Cards/DartGoblin.tscn")
	DartGoblin.t_audio_deploy = [5]
	DartGoblin.t_audio_attack = [18, 19]
	DartGoblin.t_audio_death = [28]

	Pekka.card_name = "Pekka"
	Pekka.health = 5475
	Pekka.damage = 1188
	Pekka.tower_damage = 1188
	Pekka.elixir = 7
	Pekka.hitspeed = 1.8
	Pekka.speed = 45
	Pekka.deploy_time = 1
	Pekka.target = ["ground"]
	Pekka.transport = "ground"
	Pekka.type = TYPES.TROOP
	Pekka.rarity = RARITIES.EPIC
	Pekka.scene = preload("res://Scenes/Cards/Pekka.tscn")
	Pekka.t_audio_deploy = [6]
	Pekka.t_audio_attack = [20]
	Pekka.t_audio_death = [29]

	Dumb.card_name = "Dumb"
	Dumb.health = 2472
	Dumb.damage = 463
	Dumb.tower_damage = 463
	Dumb.elixir = 4
	Dumb.hitspeed = 1.6
	Dumb.speed = 120
	Dumb.deploy_time = 1
	Dumb.target = ["buildings"]
	Dumb.transport = "ground"
	Dumb.type = TYPES.TROOP
	Dumb.rarity = RARITIES.RARE
	Dumb.scene = preload("res://Scenes/Cards/Dumb.tscn")
	Dumb.t_audio_deploy = [7]
	Dumb.t_audio_attack = [21, 22]
	Dumb.t_audio_death = [30]

var cards: Array[CardType] = [Knight, Musk, Log, MiniPekka, RoyalGiant, DartGoblin, Pekka, Dumb]

func get_card(given_name: String) -> CardType:
	for card in cards:
		if card.card_name == given_name:
			return card

	print("Card with name not found: " + given_name)
	return CardType.new()

func reload_audio() -> void:
	for card in cards:
		card.audio_deploy = []
		card.audio_attack = []
		card.audio_death = []

		for i in card.t_audio_deploy.size():
			var deploy: int = card.t_audio_deploy[i]

			card.audio_deploy.append(get_node(paths[deploy]))

		for i in card.t_audio_attack.size():
			var attack: int = card.t_audio_attack[i]

			card.audio_attack.append(get_node(paths[attack]))

		for i in card.t_audio_death.size():
			var death: int = card.t_audio_death[i]

			card.audio_death.append(get_node(paths[death]))
