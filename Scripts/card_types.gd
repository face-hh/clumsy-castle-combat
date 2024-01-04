class_name CardType

extends CharacterBody3D

var card_name: String

var health: int
var damage: int
var tower_damage: int
var elixir: int

var hitspeed: float

var speed: float
var deploy_time: int

var target: Array[String]
var transport: String

var rarity: DataType.RARITIES
var type: DataType.TYPES

var audio_deploy: Array[AudioStreamPlayer]
var audio_attack: Array[AudioStreamPlayer]
var audio_death: Array[AudioStreamPlayer]

var t_audio_deploy: Array[int]
var t_audio_attack: Array[int]
var t_audio_death: Array[int]

var scene: PackedScene

# Dynamic
var side: String
var intern: String
var total_health: int
var timer: Timer
var markers: Node3D
