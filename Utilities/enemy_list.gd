class_name EnemyList  # Stores a list of enemies
extends Resource

@export var enemy_group : Array[PackedScene] = []


func get_random_enemy() -> PackedScene:
	if enemy_group.size() == 0:
		print("Error: no enemies available in enemy group!")
		return null
	
	var random_enemy = enemy_group[randi() % enemy_group.size()]
	if random_enemy == null:
		print("Error: Selected enemy is null!")
		return null
	return random_enemy
