class_name DataType

extends Node

# SPEEDS
# 60 - Medium

# DEPLOY TIME
# seconds.

var Knight: CardType = CardType.new()
var Musk: CardType = CardType.new()

func _ready() -> void:
	Knight.card_name = "Knight"
	Knight.health = 2566
	Knight.elixir = 3
	Knight.hitspeed = 1.2
	Knight.speed = 60
	Knight.deploy_time = 1
	Knight.target = ["ground"]
	Knight.transport = "ground"
	Knight.type = "troop"
	Knight.rarity = "common"
	Knight.scene = preload("res://Scenes/Cards/Knight.tscn")

	Musk.card_name = "Musk"
	Musk.health = 1050
	Musk.damage = 318
	Musk.elixir = 4
	Musk.hitspeed = 1
	Musk.speed = 60
	Musk.deploy_time = 1
	Musk.target = ["air", "ground"]
	Musk.transport = "ground"
	Musk.type = "troop"
	Musk.rarity = "rare"
	Musk.scene = preload("res://Scenes/Cards/Musk.tscn")

var cards: Array[CardType] = [Knight, Musk]
