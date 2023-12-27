class_name CardType

extends CharacterBody3D

var card_name: String

var health: int
var damage: int
var elixir: int

var hitspeed: float

var speed: float
var deploy_time: int

var target: Array[String]
var transport: String

var rarity: String
var type: String

var scene: PackedScene

# Dynamic
var side: String
var intern: String
var total_health: int
var timer: Timer
var markers: Node3D
