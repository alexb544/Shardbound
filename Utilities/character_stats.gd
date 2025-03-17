class_name CharacterStats # Stores player controlled unit's stats
extends Resource

@export var char_name : String
@export var level     : int

@export var max_health : int
@export var max_mana   : int

@export var strength : int
@export var magic    : int
@export var speed    : int

var current_health : int 
var current_mana   : int

func _init() -> void:
	current_health = max_health
	current_mana = max_mana
