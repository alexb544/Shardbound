class_name Character
extends AnimatedSprite2D

@export var stats: CharacterStats
@export var is_enemy : bool
@export var shard_pile : ShardPile 


func _ready() -> void:
	set_character_stats(stats)
	

func set_character_stats(value : CharacterStats) -> void:
	stats = value
	stats.current_health = stats.max_health
	stats.current_mana = stats.max_mana


func get_shards():
	if shard_pile == null:
		return
	return self.shard_pile.shards
