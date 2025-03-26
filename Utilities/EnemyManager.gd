extends Node

@onready var enemy_spawns = %Enemies
@onready var stats : CharacterStats

var enemy_group : EnemyGroups = preload("res://Resources/EnemyGroups/easy_enemies.tres")
var enemies : Array = []


func _ready():
	spawn_enemies()


func spawn_enemies():
	var spawnpoints = enemy_spawns.get_children()
	var count = enemy_count()

	while enemies.size() < count: # Change to: SessionManager.battle_count later
		var enemy = enemy_group.get_random_enemy()
		enemies.append(enemy)

	for i in range(enemies.size()):
		var enemy = enemies[i]
		var spawn_enemy = enemy.instantiate()
		var point = spawnpoints[i]
		spawn_enemy.global_position = point.global_position
		add_child.call_deferred(spawn_enemy)

func enemy_count():
	var count = 0
	if SessionManager.battle_count == 1:
		count = 1
	elif SessionManager.battle_count == 2:
		count = 2
	elif SessionManager.battle_count == 3:
		count = 3
	else:
		count = 4
	return count
