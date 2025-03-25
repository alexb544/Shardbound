extends Node

@onready var party_manager = get_node("../PartyManager")
@onready var enemy_manager = get_node("../EnemyManager")

var party : Array = []   # access party members in scene
var enemies : Array = [] # access enemies in scene

var turn_order: Array = [] # Stores all characters for turn order
var turn_tracker: int      # Tracks whose turn it is

var enemy_index : int = 0  # Selected enemy's index in enemies
var target : AnimatedSprite2D 

var players_turn : bool = false
var waiting_for_input: = false

func _ready():
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
	if turn_order.is_empty():
		return # avoid future errors

	if turn_order[turn_tracker].is_enemy == true: # Enemy turn: selects random target
		await get_tree().create_timer(1).timeout
		target = target_random_party()
		#attack target
		print("random target: ", target, "\n")
		next_turn()
		current_turn()

	elif turn_order[turn_tracker].is_enemy == false: # Player turn: select action -> select target
		players_turn = true
		waiting_for_input = true
		print("waiting for player to confirm action")


func next_turn():
	turn_tracker += 1
	if turn_tracker >= turn_order.size():
		turn_tracker = 0


func target_random_party() -> AnimatedSprite2D:
	var select_target = party_manager.get_children()
	var random_target = select_target[randi() % party_manager.get_child_count()]
	return random_target


func change_selected_enemy(direction : int):
	if enemies.size() == 0:
		return
	enemy_index = (enemy_index + direction) % enemies.size()
	if enemy_index < 0:
		enemy_index = enemies.size() - 1 # goes back to first enemy in index
	highlight_enemy(enemy_index)
	print("Selected enemy: ", enemy_index)


func highlight_enemy(index : int):
	for i in range(enemies.size()):
		enemies[i].modulate = Color(1,1,1,1) # resets color
	enemies[index].modulate = Color(1,0,0,1) # highlights selected enemy
	print("selected Enemey: ", enemies[index].name)


func confirm_selection():
	if enemies.size() > 0:
		var selected_enemy = enemies[enemy_index]
		print("Confirmed Target: ", selected_enemy.name)
		waiting_for_input = false
		players_turn = false # end players turn
		enemies[enemy_index].modulate = Color(1,1,1,1) # reset color
		attack_enemy(selected_enemy)


# Temporary Function
func attack_enemy(enemy):
	if waiting_for_input:
		return

	print("Attacking: ", enemy.name, "\n")
	players_turn = false
	next_turn()
	current_turn()


func _input(event):
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
