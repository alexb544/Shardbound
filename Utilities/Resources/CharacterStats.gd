extends Resource
class_name CharacterStats

@export var name : String
@export var level : int

@export var max_health : int:
	set(value):
		max_health = value
		current_health = value

@export var max_mana : int:
	set(value):
		max_mana = value
		current_mana = value

@export var strength : int
@export var magic : int
@export var speed : int

var current_health : int
var current_mana : int


func take_damage(amount : int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	return current_health
