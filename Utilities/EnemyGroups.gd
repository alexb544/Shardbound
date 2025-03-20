extends Resource
class_name EnemyGroups

@export var enemy_group : Array[PackedScene] = []

var enemy_resource : EnemyGroups


func set_enemy_resource():
	var enemy_resource_path : String
	if SessionManager.battle_count <= 3:
		enemy_resource_path = "res://Resources/EnemyGroups/easy_enemies.tres"
	else:
		enemy_resource_path = "res://Resources/EnemyGroups/hard_enemies.tres"

	var updated_enemy_resource = load(enemy_resource_path) as EnemyGroups
	enemy_resource = updated_enemy_resource
	print(enemy_resource)
	return enemy_resource


func get_enemies_list() -> Array[PackedScene]:
	return enemy_group


func get_random_enemy() -> PackedScene:
	#print(enemy_resource)
	return enemy_group[randi() % enemy_group.size()]
