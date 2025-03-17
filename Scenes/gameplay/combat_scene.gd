extends Control
# === Variables =======================================================================
@export var party_list : PartyMembers 

@onready var party_positions = $Party
@onready var enemy_positions = $Enemies

var party : PartyMembers = preload("res://Resources/current_party.tres")
var party_nodes : Array = []
var enemy_nodes : Array = []
var turn_order : Array = []
var enemy_list : EnemyList = null
var current_turn = 0

# === Main ============================================================================
func _ready() -> void:
	CombatManager.battle_scaling()
	# TODO: currently sets "enemy set" to draw from (change later)
	set_enemy_resource("res://Resources/EnemyGroups/low_level.tres")
	load_party()
	load_enemies()
	setup_turn_order()
func _process(_delta: float) -> void:
	pass

# === Methods ==================================================================================
func load_party():
	# get all children nodes under $Party
	var spawnpoints = party_positions.get_children()
	# gets a list of current party members
	var party_members = party.getPartyList()
	
	for i in range(party_members.size()): 
		# skips iteration if unit isn't assigned/no party member avaialble
		if party_members[i] == null:
			continue 
		var unit = party_members[i].instantiate()
		# gets the spawn point at index[i]
		var spawn_point = spawnpoints[i]
		unit.global_position = spawn_point.global_position 
		add_child.call_deferred(unit)
		party_nodes.append(unit)

func load_enemies():
	# Sets a min/max(1-4) for enemy spawns based on player's level
	var enemies_count = CombatManager.combat_total
	var enemy_group = []
	var spawnpoints = enemy_positions.get_children()
	
	while enemy_group.size() < enemies_count:
		# Selects a random index from the enemy_list array using EnemyGroup Class method
		var selected_enemy = enemy_list.get_random_enemy()
		enemy_group.append(selected_enemy)
		
	for i in range(enemy_group.size()):
		var enemy_scene = enemy_group[i]
		var spawn_enemy = enemy_scene.instantiate()
		var spawn_point = spawnpoints[i]       
		
		spawn_enemy.global_position = spawn_point.global_position
		add_child.call_deferred(spawn_enemy)
		enemy_nodes.append(spawn_enemy)
		turn_order.append(spawn_enemy.stats)
	
	turn_order.sort_custom(func(a, b): return a.speed > b.speed)

func set_enemy_resource(resource_path : String):
	enemy_list = load(resource_path) as EnemyList

func setup_turn_order():
	turn_order.clear()
	for member in party_nodes:
		if member != null:
			turn_order.append(member.stats)
	
	for enemy in enemy_nodes:
		if enemy != null:
			turn_order.append(enemy.stats)
	
	turn_order.sort_custom(func(a,b): return a.speed > b.speed)
	current_turn = 0

# === Helper Functions =============================================================================
func deal_damage(_attacker, target, damage_amount):
	CombatManager.apply_damage(target, damage_amount)

func heal(target, heal_amount):
	CombatManager.heal(target, heal_amount)

func _on_health_changed(unit, new_health):
	# TODO: Update UI hp bar here
	print(unit.char_name if unit is CharacterStats else unit.enemy_name, "HP:", new_health)

func _on_unit_died(unit):
	# TODO: Remove unit from combat or play death animation for party members
	if unit is EnemyStats:
		unit.owner.queue_free()

func get_current_attacker():
	return turn_order[current_turn]

func get_selected_enemy():
	return enemy_nodes[0].stats

func calculate_damage(attacker, _target):
	var attack_stat = attacker.strength
	var base_damage = attack_stat * 2 # Modify later
	return base_damage

func next_turn():
	current_turn += 1
	if current_turn >= turn_order.size():
		current_turn = 0

# === Buttons =========================================================================
func _on_attack_pressed() -> void:
	var attacker = get_current_attacker()
	var target = get_selected_enemy()
	print("attacker: ", attacker)
	print("target: ", target)
	var damage = calculate_damage(attacker, target)
	CombatManager.damage_taken(target, damage)
	print(turn_order)
	print(enemy_nodes[0].stats.current_health)
	# add attack animations/sounds/next turn
	next_turn()

func _on_defend_pressed() -> void:
	# TODO: Reduce Damage Taken by 50% until next turn
	pass
