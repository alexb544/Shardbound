extends Node

var enemy_group : EnemyGroups = preload("res://Resources/EnemyGroups/easy_enemies.tres")
var enemies : Array = []


func _ready():
	while enemies.size() < 4: # Change to: SessionManager.battle_count later
		var enemy = enemy_group.get_random_enemy()
		enemies.append(enemy)
	
	for i in range(enemies.size()):
		var enemy = enemies[i]
		var spawn_enemy = enemy.instantiate()
		add_child.call_deferred(spawn_enemy)
