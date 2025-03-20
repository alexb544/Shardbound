extends Node

var turn_order: Array = []  # Stores all characters in turn order
var current_turn: int = 0  # Tracks whose turn it is

var enemy_group : EnemyGroups

func _ready():
	enemy_group = EnemyGroups.new()
	enemy_group = enemy_group.set_enemy_resource()
	var enemy = enemy_group.get_random_enemy() # stores the packed scene 
	print("random enemy: ", enemy) 


func start_battle():
	var party = get_tree().get_nodes_in_group("party_members") # both returing the AnimatedSprite2Ds
	var enemies = get_tree().get_nodes_in_group("enemies")
	turn_order = party + enemies  # Combines party and enemies into one array
	turn_order.sort_custom(func(a, b): return a.stats.speed > b.stats.speed)  # Sort by speed (highest -> lowest)
	current_turn = 0 

