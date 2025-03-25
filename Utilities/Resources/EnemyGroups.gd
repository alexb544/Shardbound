extends Resource
class_name EnemyGroups

@export var enemy_group : Array[PackedScene] = []

var enemy_resource : EnemyGroups

# Picks an enemy resource based on how far the player has gotten
func set_enemy_resource():
	var enemy_resource_path : String

	if SessionManager.battle_count <= 3:
		enemy_resource_path = "res://Resources/EnemyGroups/easy_enemies.tres"
	else:
		enemy_resource_path = "res://Resources/EnemyGroups/hard_enemies.tres"

	var updated_enemy_resource = load(enemy_resource_path) as EnemyGroups
	enemy_resource = updated_enemy_resource
	return enemy_resource


func get_random_enemy() -> PackedScene:
	return enemy_group[randi() % enemy_group.size()]
