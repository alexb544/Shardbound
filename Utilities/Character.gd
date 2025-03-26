extends AnimatedSprite2D

@export var stats: CharacterStats
@export var is_enemy : bool


func _ready() -> void:
	if is_enemy == false:
		stats = load("res://Resources/Characters/" + stats.name.to_lower() + ".tres")

	elif is_enemy == true:
		stats = load("res://Resources/Enemies/" + stats.name.to_lower() + ".tres")
