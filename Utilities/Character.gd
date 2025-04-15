class_name Character
extends AnimatedSprite2D

@export var stats: CharacterStats
@export var is_enemy : bool
@export var shard_pile : ShardPile 
@export var scene : PackedScene


#func _ready() -> void:
	#set_character_stats(stats)
	

func set_character_stats(value : CharacterStats) -> void:
	stats = value
	#stats.current_health = stats.max_health
	#stats.current_mana = stats.max_mana


func get_shards():
	if shard_pile == null:
		return
	return self.shard_pile.shards


func take_damage(damage : int) -> void:
	var initial_health := stats.current_health 
	stats.take_damage(damage)
	if initial_health > stats.health:
		Events.party_member_hit.emit() # modulates red and if !is_enemy, plays "hit" animation


func create_instance() -> AnimatedSprite2D:
	var instance: Character = self.duplicate()
	instance.stats.current_health = stats.max_health
	instance.stats.current_mana = stats.current_mana
	return instance
