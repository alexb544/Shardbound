class_name MapGenerator
extends Node

const X_DIST := 55
const Y_DIST := 40
const PLACEMENT_RANDOMNESS := 5
const FLOORS := 15
const MAP_WIDTH := 7
const PATHS := 6
const MONSTER_ROOM_WEIGHT := 7.5
const ELITE_ROOM_WEIGHT := 1.5
const TOWN_ROOM_WEIGHT := 6

@export var enemy_groups_pool : EnemyGroups

var random_room_type_weights = {
	Room.Type.MONSTER : 0.0,
	Room.Type.ELITE : 0.0,
	Room.Type.TOWN : 0.0
}

var random_room_type_total_weight := 0
var map_data : Array[Array]


func generate_map() -> Array[Array]:
	map_data = _generate_initial_grid()
	var starting_points := _get_random_starting_points()

	for j in starting_points:
		var current_j := j
		for i in FLOORS - 1:
			current_j = _setup_connection(i, current_j)
	
	enemy_groups_pool.setup()

	_setup_boss_room()
	_setup_random_room_weights()
	_setup_room_types()

	return map_data


func _generate_initial_grid() -> Array[Array]:
	var result : Array[Array] = []

	for i in FLOORS:
		var adjacent_rooms : Array[Room] = []
		
		for j in MAP_WIDTH:
			var current_room := Room.new()
			var offset := Vector2(randf(), randf()) * PLACEMENT_RANDOMNESS
			current_room.position = Vector2(j * X_DIST, i * -Y_DIST) + offset
			current_room.row = i
			current_room.column = j
			current_room.next_rooms = []

			# Boss room has a non-random Y
			if i == FLOORS - 1:
				current_room.position.y = (i + 1) * -Y_DIST

			adjacent_rooms.append(current_room)
		
		result.append(adjacent_rooms)
	
	return result


func _get_random_starting_points() -> Array[int]:
	var y_coordinates : Array[int]
	var unique_points : int = 0

	while unique_points < 2:
		unique_points = 0
		y_coordinates = []

		for i in PATHS:
			var starting_point := randi_range(0, MAP_WIDTH - 1)
			if not y_coordinates.has(starting_point):
				unique_points += 1

			y_coordinates.append(starting_point)
	
	return y_coordinates


func _setup_connection(i : int, j : int) -> int:
	var next_room : Room = null
	var current_room := map_data[i][j] as Room

	while not next_room or _would_cross_existing_path(i, j, next_room):
		var random_j := clampi(randi_range(j - 1, j + 1), 0, MAP_WIDTH - 1)
		next_room = map_data[i + 1][random_j]
	
	current_room.next_rooms.append(next_room)

	return next_room.column


func _would_cross_existing_path(i : int, j : int, room : Room) -> bool:
	var left_neighbour : Room
	var right_neighbour : Room

	# if j == 0, no left neighbour
	if j > 0:
		left_neighbour = map_data[i][j - 1]
	# if j == MAP_WIDTH - 1, no right neighbour
	if j < MAP_WIDTH - 1:
		right_neighbour = map_data[i][j + 1]

	# can't cross in right dir if right neighbour goes to left
	if right_neighbour and room.column > j:
		for next_room : Room in right_neighbour.next_rooms:
			if next_room.column < room.column:
				return true
	
	# can't cross in left dir if left neighbour goes to right
	if left_neighbour and room.column < j:
		for next_room : Room in left_neighbour.next_rooms:
			if next_room.column > room.column:
				return true
					
	return false


func _setup_boss_room() -> void:
	var middle := floori(MAP_WIDTH * 0.5)
	var boss_room := map_data[FLOORS - 1][middle] as Room

	for j in MAP_WIDTH:
		var current_room = map_data[FLOORS - 2][j] as Room
		if current_room.next_rooms:
			current_room.next_rooms = [] as Array[Room]
			current_room.next_rooms.append(boss_room)

	boss_room.type = Room.Type.BOSS
	boss_room.battle_stats = enemy_groups_pool.get_random_battle_for_tier(3)


func _setup_random_room_weights() -> void:
	random_room_type_weights[Room.Type.MONSTER] = MONSTER_ROOM_WEIGHT
	random_room_type_weights[Room.Type.ELITE] = MONSTER_ROOM_WEIGHT + ELITE_ROOM_WEIGHT
	random_room_type_weights[Room.Type.TOWN] = MONSTER_ROOM_WEIGHT + ELITE_ROOM_WEIGHT + TOWN_ROOM_WEIGHT

	random_room_type_total_weight = random_room_type_weights[Room.Type.TOWN]


func _setup_room_types() -> void:
	# first floor is always a battle
	for room : Room in map_data[0]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.MONSTER
			room.battle_stats = enemy_groups_pool.get_random_battle_for_tier(0)
	
	# Disabled For QualCon, Treasure Room not finished
	# # 9th floor is always loot
	# for room : Room in map_data[floori(FLOORS / 2)]:
	# 	if room.next_rooms.size() > 0:
	# 		room.type = Room.Type.TREASURE
	
	# last floor before boss is always a town
	for room : Room in map_data[FLOORS - 2]:
		if room.next_rooms.size() > 0:
			room.type = Room.Type.TOWN

	# rest of rooms
	for current_floor in map_data:
		for room : Room in current_floor:
			for next_room : Room in room.next_rooms:
				if next_room.type == Room.Type.NOT_ASSIGNED:
					_set_room_randomly(next_room)


func _set_room_randomly(room_to_set : Room) -> void:
	var town_below_4 := true
	var consecutive_town := true
	var consecutive_elite := true
	var elite_below_4 := true
	var town_on_13 := true

	var type_candidate : Room.Type

	while town_below_4 or elite_below_4 or consecutive_town or consecutive_elite or town_on_13:
		type_candidate = _get_random_room_type_by_weight()

		var is_town := type_candidate == Room.Type.TOWN
		var has_town_parent := _room_has_parent_of_type(room_to_set, Room.Type.TOWN)
		var is_elite := type_candidate == Room.Type.ELITE
		var has_elite_parent := _room_has_parent_of_type(room_to_set, Room.Type.ELITE)

		town_below_4 = is_town and room_to_set.row < 2
		consecutive_town = is_town and has_town_parent
		elite_below_4 = is_elite and room_to_set.row < 3
		consecutive_elite = is_elite and has_elite_parent
		town_on_13 = is_town and room_to_set.row == FLOORS - 3
	
	room_to_set.type = type_candidate

	# Assigns difficulty for MONSTER fights
	if type_candidate == Room.Type.MONSTER:
		var tier_for_monster_rooms := 0

		if room_to_set.row > 2:
			tier_for_monster_rooms = 1 # Normal Enemy Pool

		if room_to_set.row > 8:
			tier_for_monster_rooms = 4 # Hard Enemy Pool

		room_to_set.battle_stats = enemy_groups_pool.get_random_battle_for_tier(tier_for_monster_rooms)
	
	if type_candidate == Room.Type.ELITE:
		var tier_for_elite_rooms := 2

		room_to_set.battle_stats = enemy_groups_pool.get_random_battle_for_tier(tier_for_elite_rooms)


func _room_has_parent_of_type(room : Room, type : Room.Type) -> bool:
	var parents : Array[Room] = []
	# left parent
	if room.column > 0 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column - 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# parent below
	if room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	# right parent
	if room.column < MAP_WIDTH - 1 and room.row > 0:
		var parent_candidate := map_data[room.row - 1][room.column + 1] as Room
		if parent_candidate.next_rooms.has(room):
			parents.append(parent_candidate)
	
	for parent : Room in parents:
		if parent.type == type:
			return true
	
	return false


func _get_random_room_type_by_weight() -> Room.Type:
	var roll := randf_range(0.0, random_room_type_total_weight)

	for type : Room.Type in random_room_type_weights:
		if random_room_type_weights[type] > roll:
			return type
	
	return Room.Type.MONSTER
