class_name EnemyManager
extends Node

@onready var enemy_spawns = %Enemies
@onready var enemy_container = %EnemyList
@onready var stats : CharacterStats

var enemy_group : EnemyGroups
var enemies : Array[PackedScene] = []
var spawned_enemies : Array = []


func _ready():
	spawn_enemies()
	set_enemy_ui()


func spawn_enemies():
	enemies = enemy_group._get_enemy_group()
	var spawnpoints = enemy_spawns.get_children()

	for i in range(enemies.size()):
		var enemy = enemies[i]
		var spawn_enemy = enemy.instantiate()
		var point = spawnpoints[i]

		spawn_enemy.stats = spawn_enemy.stats.duplicate(true) # ensures enemies don't share stats
		spawn_enemy.stats.current_health = spawn_enemy.stats.max_health

		spawn_enemy.global_position = point.global_position
		
		add_child.call_deferred(spawn_enemy)
		spawned_enemies.append(spawn_enemy)


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
