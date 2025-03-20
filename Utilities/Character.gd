extends AnimatedSprite2D

@export var stats: CharacterStats
@export var is_enemy : bool

var health : int 
var mana : int 


func _ready() -> void:
	if is_enemy == false:
		stats = load("res://Resources/Characters/" + stats.name.to_lower() + ".tres")
	if is_enemy == true:
		stats = load("res://Resources/Enemies/" + stats.name.to_lower() + ".tres")
