extends Node

# SPEEDS
# 60 - Medium

# DEPLOY TIME
# seconds.

var cards: Array = [
	{
		"name": "Knight",
		"health": 2566,
		"damage": 293,
		"elixir": 3,
		"hitspeed": 1.2,
		"speed": 60,
		"deploy_time": 1,
		"target": ["ground"],
		"transport": "ground",
		"type": "troop",
		"rarity": "common",
		"scene": preload("res://Scenes/Cards/Knight.tscn")
	},
		{
		"name": "Musk",
		"health": 1050,
		"damage": 318,
		"elixir": 4,
		"hitspeed": 1,
		"speed": 60,
		"deploy_time": 1,
		"target": ["air", "ground"],
		"transport": "ground",
		"type": "troop",
		"rarity": "rare",
		"scene": preload("res://Scenes/Cards/Musk.tscn")
	},
]
