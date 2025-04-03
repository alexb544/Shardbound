class_name Character
extends AnimatedSprite2D

signal attacking(damage)


@export var stats: CharacterStats
@export var is_enemy : bool


func _ready() -> void:
	get_stats()


func get_stats():
	if stats:
		var path : String
		if !is_enemy:
			path = "res://Resources/Characters/" + stats.name.to_lower() + ".tres"
		else:
			path = "res://Resources/Enemies/" + stats.name.to_lower() + ".tres"
		
		var loaded_stats = ResourceLoader.load(path) as CharacterStats
		if loaded_stats:
			stats.max_health = loaded_stats.max_health
			stats.max_mana = loaded_stats.max_mana
			stats.strength = loaded_stats.strength
			stats.magic = loaded_stats.magic
			stats.speed = loaded_stats.speed

			stats.current_health = loaded_stats.max_health
			stats.current_mana = loaded_stats.max_mana


func attack(target : AnimatedSprite2D):
	var damage = stats.strength
	attacking.emit(damage)
	target.stats.current_health -= damage
