extends Node
class_name EnemyManager

@onready var enemy_spawns = %Enemies
@onready var enemy_container = %EnemyList
@onready var stats : CharacterStats

var enemy_group : EnemyGroups = preload("res://Resources/EnemyGroups/easy_enemies.tres")
var enemies : Array = []
var spawned_enemies : Array = []


func _ready():
	spawn_enemies()
	set_enemy_ui()


func spawn_enemies():
	var spawnpoints = enemy_spawns.get_children()
	var count = enemy_count()

	while enemies.size() < count:
		var enemy = enemy_group.get_random_enemy()
		enemies.append(enemy)

	for i in range(enemies.size()):
		var enemy = enemies[i]
		var spawn_enemy = enemy.instantiate()
		var point = spawnpoints[i]

		spawn_enemy.stats = spawn_enemy.stats.duplicate(true) # ensures enemies don't share stats

		spawn_enemy.global_position = point.global_position
		
		add_child.call_deferred(spawn_enemy)
		spawned_enemies.append(spawn_enemy)


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


func set_enemy_ui():
	for i in range(enemy_container.get_child_count()): # EnemyList -> (NME1, 2, 3, 4)
		var unit_ui = enemy_container.get_child(i) # Enemy(i) -> (Icon, HP/Label)

		if i < spawned_enemies.size():
			var unit = spawned_enemies[i]
			var icon = unit_ui.get_node("Icon") as TextureRect
			icon.texture = unit.stats.icon

			var health_bar = unit_ui.get_node("HealthBar") as ProgressBar
			health_bar.max_value = unit.stats.max_health
			health_bar.value = unit.stats.current_health

			var health_text = health_bar.get_node("Label") as Label
			health_text.text = str(unit.stats.current_health)

			unit.stats.health_changed.connect(_on_health_changed.bind(health_bar, health_text))

			unit_ui.visible = true
			
		else:
			unit_ui.visible = false


func _on_health_changed(value, health_bar, health_text):
	health_bar.value = value
	health_text.text = str(value)

	if health_bar.value == 0:
		health_bar.get_parent().visible = false