class_name DataType

extends Node

enum RARITIES {COMMON, RARE, EPIC, LEGENDARY, CHAMPION}
enum TYPES {SPELL, TROOP, BUILDING}
# SPEEDS
# 60 - Medium

# DEPLOY TIME
# seconds.

var Knight: CardType = CardType.new()
var Musk: CardType = CardType.new()
var Log: CardType = CardType.new()
var MiniPekka: CardType = CardType.new()

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

var cards: Array[CardType] = [Knight, Musk, Log, MiniPekka]

func get_card(given_name: String) -> CardType:
	for card in cards:
		if card.card_name == given_name:
			return card

	print("Card with name not found: " + given_name)
	return CardType.new()
