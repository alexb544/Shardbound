class_name EnemyStats # Stores enemy unit's stats
extends Resource

@export var enemy_name : String = ""

@export var max_health : int
@export var damage : int
@export var speed : int

@export var exp_earned : int 


var current_health : int 

func _init() -> void:
	current_health = max_health
