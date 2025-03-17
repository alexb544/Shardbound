extends Control
# === Variables =======================================================================
@export var party_list   : PartyMembers 
@export var player_stats : CharacterStats = preload("res://Resources/Characters/Player.tres")

@onready var party_positions = $Party
@onready var enemy_positions = $Enemies

var party      : PartyMembers = preload("res://Resources/current_party.tres")
var party_nodes : Array = []
var enemy_list : EnemyList = null
var turn_order = []
var current_turn = 0

# === Main ============================================================================
func _ready() -> void:
	var player_level = get_player_level()
	load_party()
	set_enemy_resource("res://Resources/EnemyGroups/low_level.tres")
	load_enemies(player_level)
	setup_turn_order()
	print(party_list)
func _process(_delta: float) -> void:
	pass

# === Methods ==================================================================================
func load_party():
	var spawnpoints = party_positions.get_children() # get all children nodes under $Party
	var party_members = party.getPartyList() # gets a list of current party members
	
	for i in range(party_members.size()): 
		if party_members[i] == null: # skips iteration if unit isn't assigned/no party member avaialble
			continue 
		var unit = party_members[i].instantiate()
		var spawn_point = spawnpoints[i] # gets the spawn point at index[i]
		unit.global_position = spawn_point.global_position 
		add_child.call_deferred(unit)
		party_nodes.append(unit)

func load_enemies(level: int):
	if enemy_list == null:
		print("Error: Enemy list not valid")
		return
	
	var enemies_count = clamp(level, 1, 4) # Sets a min/max(1-4) for enemy spawns based on player's level. 
	var enemy_group = []
	var spawnpoints = enemy_positions.get_children() # Indexs Children Nodes under $Enemies
	
	while enemy_group.size() < enemies_count:
		var selected_enemy = enemy_list.get_random_enemy() # Selects a random index from the enemy_list array using EnemyGroup Class method
		if selected_enemy == null:
			print("No valid enemy returned, retrying")
			continue
		enemy_group.append(selected_enemy)
		
	for i in range(enemy_group.size()):
		var enemy_scene = enemy_group[i]
		var spawn_enemy = enemy_scene.instantiate()
		var spawn_point = spawnpoints[i]             
		spawn_enemy.global_position = spawn_point.global_position
		add_child.call_deferred(spawn_enemy)
		turn_order.append(spawn_enemy.stats)
	turn_order.sort_custom(func(a, b): return a.speed > b.speed)

func get_player_level() -> int:
	if player_stats:
		return player_stats.level # Gets player's level 
	else:
		print("Error: Stats resource not loaded.")
		return 1 # Default

func set_enemy_resource(resource_path : String):
	enemy_list = load(resource_path) as EnemyList
	if not enemy_list:
		print("Failed to load enemy resource from:", resource_path)
		return
	print("Enemy resource loaded successfully: ", enemy_list)
	
	if enemy_list.enemy_group.size() == 0:
		print("Error: enemy_group is empty!")
	else:
		print("Enemy group loaded with ", enemy_list.enemy_group.size(), " enemies.")

func setup_turn_order():
	turn_order.clear()
	
	for member in party_nodes:
		if member != null:
			turn_order.append(member.stats)
	
	var enemies = get_tree().get_nodes_in_group("Enemies")
	for enemy in enemies:
		if enemy != null and enemy.stats != null:
			turn_order.append(enemy.stats)
	
	turn_order.sort_custom(func(a,b): return a.speed > b.speed)
	current_turn = 0

# === Helper Functions =============================================================================
func deal_damage(_attacker, target, damage_amount):
	CombatManager.apply_damage(target, damage_amount)

func heal(target, heal_amount):
	CombatManager.heal(target, heal_amount)

func _on_health_changed(unit, new_health):
	print(unit.char_name if unit is CharacterStats else unit.enemy_name, "HP:", new_health)
	#Update UI hp bar here

func _on_unit_died(unit):
	print(unit.char_name if unit is CharacterStats else unit.enemy_name, "has died!")
	# Remove unit from combat or play death animation
	if unit is EnemyStats:
		unit.owner.queue_free() # removes enemy from scene

func get_current_attacker():
	if turn_order.is_empty():
		return null
	print(current_turn)
	return turn_order[current_turn]

func get_selected_enemy():
	return get_tree().get_nodes_in_group("Enemies").front()

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
	if attacker == null or target == null:
		print("Error: No attacker or target selected!")
		return
	var damage = calculate_damage(attacker, target)
	print(attacker.char_name, "attacks", target.enemy_name, "for", damage, "damage!")
	CombatManager.damage_taken(target, damage)
	# add attack animations/sounds/next turn
	next_turn()

func _on_defend_pressed() -> void:
	# TODO: Reduce Damage Taken by 50% until next turn
	pass
