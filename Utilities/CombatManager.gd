extends Node

#signal textbox

@onready var party_manager = get_node("../PartyManager")
@onready var enemy_manager = get_node("../EnemyManager")

var party : Array = []   # access party members in scene
var enemies : Array = [] # access enemies in scene

var turn_order: Array = [] # Stores all characters for turn order
var turn_tracker: int      # Tracks whose turn it is
var turn : AnimatedSprite2D # Current unit's turn.

var enemy_index : int = 0  # Selected enemy's index in enemies
var target : AnimatedSprite2D 

var players_turn : bool = false
var waiting_for_input: bool = false
var battle_over : bool = false

func _ready():
	print("Battle Scene loaded")
	await get_tree().process_frame # Wait to load party/enemies in before setting turn order

	party = party_manager.get_children()
	enemies = enemy_manager.get_children()

	set_turn_order()

	current_turn()

# Appends party/enemies stats.speed to turn_order[] & sorts them (high -> low)
func set_turn_order():
	turn_order = party + enemies
	turn_order.sort_custom(func(a,b): return a.stats.speed > b.stats.speed)
	return turn_order

# Determines if current turn is party/enemy
func current_turn():
	
	battle_status()
	if battle_over == true:
		return
	
	print(turn_order[turn_tracker].name, "'s turn!") # "Unit's Turn!"
	turn = turn_order[turn_tracker] # Stores active unit

	# Enemy turn: selects random target
	if turn.is_enemy == true && battle_over == false:
		var current_position = turn.global_position
		var offset = Vector2(-50, -10)

		await get_tree().create_timer(.75).timeout # Enemy makes "decision"

		target = target_random_party()
		target.stats.current_health -= turn.stats.strength

		await move_next_to_target(offset) # move to targeted party member
		
		print("Random Target: ", target.stats.name) # "Random Target: Player"
		print(turn.name, " Attacks!") # "Rat Attacks!"
		
		target.modulate = Color(1,0,0,1)
		target.play("hit") # plays "hit" animation for the attacked party member.
		await get_tree().create_timer(.75).timeout # delays the "hit" animation 1 second before going back to "default"
		target.modulate = Color(1,1,1,1)
		await move_next_to_target(current_position - target.global_position)

		if target.stats.current_health == 0:
			pass
			# play death animation here
			# remove target from the scene
		else:
			target.play("default")
		
		next_turn()
		print("\n === Next Turn === \n")
		current_turn()

	elif turn.is_enemy == false && battle_over == false: # Player turn: select action -> select target
		players_turn = true
		waiting_for_input = true
		turn.play("turn") # active turn animation
		print("Waiting on target confirmation...")

# Increments turn count 
func next_turn():
	turn_tracker += 1
	if turn_tracker >= turn_order.size():
		turn_tracker = 0

# Enemy Targeting
func target_random_party() -> AnimatedSprite2D:
	var select_target = party_manager.get_children()
	var random_target = select_target[randi() % party_manager.get_child_count()]
	return random_target

# Select an enemy; highlights selected enemy
func change_selected_enemy(direction : int):
	if enemies.size() == 0:
		return

	enemy_index = (enemy_index + direction) % enemies.size()

	if enemy_index < 0:
		enemy_index = enemies.size() - 1 # goes back to first enemy in index
	highlight_enemy(enemy_index)

# Helper: highlight targeted enemy 
func highlight_enemy(index : int):
	for i in range(enemies.size()):
		enemies[i].modulate = Color(1,1,1,1) # resets color
	enemies[index].modulate = Color(1,0,0,1) # highlights selected enemy
	print("> Selected Enemey: ", enemies[index].name)

# Confirms target to attack
func confirm_selection():
	if enemies.size() > 0 && enemy_index < enemies.size():
		var selected_enemy = enemies[enemy_index]
		print("Confirmed Target: ", selected_enemy.name)
		
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

	print(turn.name, " attacks ", enemy.name, "!\n")

	turn.play("move")
	await move_next_to_target(offset) # move to selected enemy

	turn.play("attack")
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
	if unit.is_enemy == true:
		enemies.erase(unit)
	else:
		party.erase(unit)

	turn_order.erase(unit)
	unit.queue_free()


func party_victory():
	for unit in party:
		unit.play("win_before")

		if unit == party[party.size() - 1]:
			await party[0].animation_finished

			for i in party:
				i.play("win_after")


func battle_status():
	if party.is_empty():
		battle_over = true
		Events.battle_over_screen_requested.emit("Game Over!", BattleOverPanel.Type.LOSE)

	if enemies.is_empty():
		battle_over = true
		party_victory()
		Events.battle_over_screen_requested.emit("You Win!", BattleOverPanel.Type.WIN)


func _input(event : InputEvent) -> void:
	if players_turn and waiting_for_input:

			if event.is_action_pressed("right"):
				change_selected_enemy(-1)

			elif event.is_action_pressed("left"):
				change_selected_enemy(1)

			elif event.is_action_pressed("confirm"):
				confirm_selection()


func _on_attack_pressed() -> void:
	print("Attack button pressed")


func _on_defend_pressed() -> void:
	print("Defend button pressed")


# func _textbox(text : String):
# 	$Textbox/Label.text = text
# 	emit_signal("textbox")
