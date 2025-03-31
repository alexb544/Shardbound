class_name Run
extends Node

const BATTLE_SCENE := preload("res://Scenes/battle/combat_scene.tscn")
const BATTLE_REWARD_SCENE := preload("res://Scenes/battle_reward/battle_reward.tscn")
const TOWN_SCENE := preload("res://Scenes/town/town.tscn")
const MAP_SCENE := preload("res://Scenes/map/map.tscn")
const LOOT_ROOM_SCENE := preload("res://Scenes/loot_room/loot_room.tscn")

@export var run_startup : RunStartup

@onready var current_view : Node = $CurrentView 
@onready var map_button : Button = %MapButton
@onready var battle_button : Button = %BattleButton 
@onready var town_button : Button = %TownButton 
@onready var loot_room_button : Button = %LootRoomButton 
@onready var rewards_button : Button = %RewardButton 

var current_party : CurrentParty = preload("res://Resources/current_party.tres")
var new_party : CurrentParty = preload("res://Resources/new_party.tres")


func _ready():
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			current_party = new_party
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("TODO: load previous Run")


func _start_run() -> void:
	_setup_event_connections()
	print("TODO: procedurally generate map")


func _change_view(scene : PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	var new_view := scene.instantiate()
	current_view.add_child(new_view)


func _setup_event_connections() -> void:
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	Events.battle_reward_exited.connect(_change_view.bind(MAP_SCENE))
	Events.town_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.loot_room_exited.connect(_change_view.bind(MAP_SCENE))

	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	town_button.pressed.connect(_change_view.bind(TOWN_SCENE))
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	loot_room_button.pressed.connect(_change_view.bind(LOOT_ROOM_SCENE))


func _on_map_exited() -> void:
	print("TODO: from the MAP, change view based on room type")
