class_name CombatManager
extends Node

#signal textbox

@onready var party_manager = get_node("../PartyManager")
@onready var enemy_manager = get_node("../EnemyManager")
@onready var shards_button : MenuButton = %Shards 
@onready var attack_button : Button = %Attack

var party : Array = []   # access party members in scene
var enemies : Array = [] # access enemies in scene

var turn_order: Array = [] # Stores all characters for turn order
var turn_tracker: int # Tracks whose turn it is
var turn : AnimatedSprite2D # Current unit's turn.

var enemy_index : int = 0  # Selected enemy's index in enemies
var target : AnimatedSprite2D # Used only for enemy targeting

var players_turn : bool = false
var waiting_for_input: bool = false
var battle_over : bool = false
var shard_list : Array[Resource] # Current turn's shardpile


func _ready():
	battle_over = false
	print("Battle Scene loaded")
	await get_tree().process_frame # Wait to load party/enemies in before setting turn order

	party = party_manager.get_children()
	enemies = enemy_manager.get_children()
	set_turn_order()
	current_turn()
	battle_over = false
	
# Appends party/enemies stats.speed to turn_order[] & sorts them (high -> low)
func set_turn_order():
	turn_order = party + enemies
	turn_order.sort_custom(func(a,b): return a.stats.speed > b.stats.speed)
	return turn_order

# Determines if current turn is party/enemy
func current_turn():
	disable_buttons()
	battle_status()
	if battle_over == true:
		return

	turn = turn_order[turn_tracker] # Stores active unit

	# Enemy turn: selects random target
	if turn.is_enemy == true && battle_over == false:
		var current_position = turn.global_position
		var offset = Vector2(-50, -10)

		await get_tree().create_timer(.75).timeout # Enemy makes "decision"
		target = target_random_party()
		target.stats.current_health -= turn.stats.strength
		await move_next_to_target(offset) # move to targeted party member
		
		target.modulate = Color(1,0,0,1)
		target.play("hit") # plays "hit" animation for the attacked party member.
		await get_tree().create_timer(.75).timeout # delays the "hit" animation 1 second before going back to "default"
		target.modulate = Color(1,1,1,1)
		await move_next_to_target(current_position - target.global_position)

		if target.stats.current_health == 0:
			remove_unit(target)
		else:
			target.play("default")
		
		end_turn()
	
	# Player turn: select action -> select target
	elif turn.is_enemy == false && battle_over == false:
		players_turn = true
		waiting_for_input = true
		enable_buttons()

		shard_list = turn.get_shards()
		generate_shard_list()

		turn.play("turn") # active turn animation


func next_turn(): # Increments turn count 
	turn_tracker += 1
	if turn_tracker > turn_order.size() - 1:
		turn_tracker = 0


func end_turn():
	players_turn = false
	waiting_for_input = false
	next_turn()
	current_turn()


func target_random_party() -> AnimatedSprite2D: # Enemy Targeting
	var select_target = party_manager.get_children()
	var random_target = select_target[randi() % party_manager.get_child_count()]
	return random_target


func change_selected_enemy(direction : int): # Select an enemy; highlights selected enemy
	if enemies.size() == 0:
		return
	enemy_index = (enemy_index + direction) % enemies.size()

	if enemy_index < 0:
		enemy_index = enemies.size() - 1 # goes back to first enemy in index
	highlight_enemy(enemy_index)


func highlight_enemy(index : int): # Helper: highlight targeted enemy 
	for i in range(enemies.size()):
		enemies[i].modulate = Color(1,1,1,1) # resets color
	enemies[index].modulate = Color(1,0,0,1) # highlights selected enemy


func confirm_selection(): # Confirms target to attack
	if enemies.size() > 0 && enemy_index < enemies.size():
		disable_buttons()
		var selected_enemy = enemies[enemy_index]		
		waiting_for_input = false
		players_turn = false # end players turn

		enemies[enemy_index].modulate = Color(1,1,1,1) # reset color
		attack_enemy(selected_enemy)
	else:
		pass # passes if invalid selection (usually out of range)


func attack_enemy(enemy: AnimatedSprite2D):
	if waiting_for_input:
		return
	var current_position = turn.global_position
	var offset = Vector2(50, -10)

	turn.play("move") # moves to target
	await move_next_to_target(offset) # move to selected enemy

	turn.play("attack") # plays attack animation
	enemy.stats.current_health -= turn.stats.strength

	if enemy.stats.current_health > 0:
		enemy.play("hit")
		await turn.animation_finished # wait for attack animation to finish

		turn.play("move")
		await move_next_to_target(current_position - enemy.global_position) # move back to starting position

		turn.play("default")
		enemy.play("default")
	else:
		await turn.animation_finished # wait for attack animation to finish
		enemy.skew = 89.9
		turn.play("move")
		await move_next_to_target(current_position - enemy.global_position) # move back to starting position

		turn.play("default")
		remove_unit(enemy) # wait for player to return to starting postion

	next_turn()
	current_turn()


func move_next_to_target(offset: Vector2, duration: float = 0.4 ):
	if turn_order[turn_tracker].is_enemy == false:
		var target_position = enemies[enemy_index].global_position + offset
		var tween = get_tree().create_tween()
		tween.tween_property(turn, "global_position", target_position, duration)
		await tween.finished
	else:
		var target_position = target.global_position + offset
		var tween = get_tree().create_tween()
		tween.tween_property(turn, "global_position", target_position, duration)
		await tween.finished


func remove_unit(unit : AnimatedSprite2D):
	if unit.is_enemy and unit.stats.current_health <= 0:
		enemies.erase(unit)
		turn_order.erase(unit)
		unit.queue_free()

	elif !unit.is_enemy and unit.stats.current_health <= 0:
		party.erase(unit)
		turn_order.erase(unit)
		unit.queue_free()


func battle_status(): # checks if battle is over
	if party.is_empty() or GlobalParty.current_party.party_members[0].stats.current_health <= 0:
		battle_over = true
		Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)

	if enemies.is_empty():
		battle_over = true
		party_victory()
		Events.battle_over_screen_requested.emit("You Win!", BattleOverPanel.Type.WIN)


func party_victory():
	for unit in party:
		unit.play("win_before")

		if unit == party[party.size() - 1]:
			await party[0].animation_finished

			for i in party:
				i.play("win_after")


func _input(event : InputEvent) -> void:
	if players_turn and waiting_for_input:

			if event.is_action_pressed("right"):
				change_selected_enemy(-1)

			elif event.is_action_pressed("left"):
				change_selected_enemy(1)

			elif event.is_action_pressed("confirm"):
				confirm_selection()


func _on_attack_pressed() -> void:
	if players_turn:
		confirm_selection()
	else:
		print("Wait your turn!")


func generate_shard_list():
	var popup = shards_button.get_popup()
	popup.clear()
	
	if shard_list.is_empty():
		return 

	for shard in shard_list:
		var index = popup.get_item_count()
		popup.add_item(shard.id)
		popup.set_item_icon(index, shard.icon)

		if not popup.is_connected("id_pressed", Callable(self, "_on_shard_option_selected")):
			popup.connect("id_pressed", Callable(self, "_on_shard_option_selected"))


func _on_shard_option_selected(i : int) -> void:
	if enemies.size() > 0 && enemy_index < enemies.size():

		if i >= 0 and i < shard_list.size():
			if shard_list[i].type == 0:
				disable_buttons()
				var target_array : Array[Node]
				target_array.append(enemies[enemy_index])

				turn.play("shard_cast")
				await get_tree().create_timer(1).timeout

				shard_list[i].play(target_array, turn.stats)
				if i >= 0 and i < target_array.size() and target_array[i]:
					remove_unit(target_array[i] as AnimatedSprite2D)
			
			if shard_list[i].type == 1:
				disable_buttons()
				var target_array : Array[Node]
				target_array.append(party[0])
				turn.play("shard_cast")
				await get_tree().create_timer(1).timeout
				shard_list[i].play(target_array, turn.stats)
			
			players_turn = false
			turn.play("default")
			end_turn()

	else:
		print("invalid shard ID: ", i)


func _on_shards_toggled(toggled_on: bool) -> void:
	if toggled_on and players_turn:
		turn.play("shard_charge")
	
	if !toggled_on and players_turn:
		if turn:
			turn.play("turn")
		else:
			turn.play("default")


func disable_buttons() -> void:
	attack_button.disabled = true
	shards_button.disabled = true


func enable_buttons() -> void:
	attack_button.disabled = false
	shards_button.disabled = false
