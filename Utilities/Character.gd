class_name Character
extends AnimatedSprite2D

@export var stats: CharacterStats
@export var is_enemy : bool
@export var shards : Array[Resource]


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


func add_shard(shard : Resource) -> void:
	if shards.size() < 3:
		shards.append(shard)
	else:
		print("You already have 3 shards equipped!")
		return


func get_shards() -> Array[Resource]:
	return shards