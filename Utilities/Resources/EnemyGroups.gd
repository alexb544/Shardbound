class_name EnemyGroups
extends Resource

@export_range(0, 4) var battle_tier : int # [0 = easy, 1 = normal, 2 = elite, 3 = boss, 4 = hard] (5 options total)
@export_range(0.0, 10.0) var weight : float
@export var gold_reward_min : int
@export var gold_reward_max : int
@export var exp_reward : int
@export var enemies : Array[PackedScene] = []

@export var pool : Array[EnemyGroups]

var accumulated_weight : float = 0.0 
var total_weights_by_tier := [0.0, 0.0, 0.0, 0.0, 0.0]


func _get_enemy_group() -> Array[PackedScene]:
	var enemy_array : Array[PackedScene] = []
	if EnemyGroups: 
		for i in range(enemies.size()):
			enemy_array.append(enemies[i])

	return enemy_array


func roll_gold_reward() -> int:
	return randi_range(gold_reward_min, gold_reward_max)


func _get_all_battle_for_tier(tier : int) -> Array[EnemyGroups]:
	return pool.filter(
		func(battle : EnemyGroups):
			return battle.battle_tier == tier
	)


func _setup_weight_for_tier(tier : int) -> void:
	var battles := _get_all_battle_for_tier(tier)
	total_weights_by_tier[tier] = 0.0 

	for battle : EnemyGroups in battles:
		total_weights_by_tier[tier] += battle.weight
		battle.accumulated_weight = total_weights_by_tier[tier]


func get_random_battle_for_tier(tier : int) -> EnemyGroups:
	var roll := randf_range(0.0, total_weights_by_tier[tier])
	var battles := _get_all_battle_for_tier(tier)

	for battle : EnemyGroups in battles:
		if battle.accumulated_weight > roll:
			return battle
	
	return null


func setup() -> void:
	for i in 5: # changed from 4 -> 5
		_setup_weight_for_tier(i)
