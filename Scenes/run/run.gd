class_name Run
extends Node

const BATTLE_SCENE := preload("res://Scenes/battle/combat_scene.tscn")
const BATTLE_REWARD_SCENE := preload("res://Scenes/battle_reward/battle_reward.tscn")
const TOWN_SCENE := preload("res://Scenes/town/town.tscn")
const LOOT_ROOM_SCENE := preload("res://Scenes/loot_room/loot_room.tscn")
const PARTY_MENU_SCENE := preload("res://Scenes/ui/party_menu.tscn")

@export var run_startup : RunStartup

@onready var map : Map = $Map
@onready var current_view : Node = $CurrentView
@onready var map_button : Button = %MapButton
@onready var battle_button : Button = %BattleButton 
@onready var town_button : Button = %TownButton 
@onready var loot_room_button : Button = %LootRoomButton 
@onready var rewards_button : Button = %RewardButton

@onready var gold_ui : GoldUI = %GoldUI
@onready var party_menu_button : TextureButton = %PartyMenuButton 

var current_party : CurrentParty
var run_stats : RunStats


func _ready():
	if not run_startup:
		return
	
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			current_party = run_startup.current_party.create_new_party()
			_start_run()

		RunStartup.Type.CONTINUED_RUN:
			print("TODO: load previous Run")


func _start_run() -> void:
	run_stats = RunStats.new()

	_setup_event_connections()
	_setup_top_bar()
	map.generate_new_map()
	map.unlock_floor(0)


func _change_view(scene : PackedScene) -> Node:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()

	var new_view := scene.instantiate()
	current_view.add_child.call_deferred(new_view)
	map.hide_map()
	
	return new_view


func _show_map() -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	map.show_map()
	map.unlock_next_rooms()


func _setup_event_connections() -> void:
	Events.battle_won.connect(_on_battle_won)
	Events.battle_reward_exited.connect(_show_map)
	Events.town_exited.connect(_show_map)
	Events.map_exited.connect(_on_map_exited)
	Events.loot_room_exited.connect(_show_map)

	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	town_button.pressed.connect(_change_view.bind(TOWN_SCENE))
	map_button.pressed.connect(_show_map)
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARD_SCENE))
	loot_room_button.pressed.connect(_change_view.bind(LOOT_ROOM_SCENE))


func _setup_top_bar():
	gold_ui.run_stats = run_stats


func _on_battle_room_entered(room : Room) -> void:
	var battle_scene : Battle = _change_view(BATTLE_SCENE) as Battle
	battle_scene.battle_stats = room.battle_stats

	var party_manager : PartyManager = battle_scene.get_node("PartyManager") as PartyManager
	party_manager.current_party = self.current_party

	var enemy_manager : EnemyManager = battle_scene.get_node("EnemyManager") as EnemyManager
	enemy_manager.enemy_group = battle_scene.battle_stats
	
	battle_scene.start_battle()
	

func _on_battle_won() -> void:
	var reward_scene := _change_view(BATTLE_REWARD_SCENE) as BattleReward
	await get_tree().create_timer(.01).timeout # game crashes if this isn't included (change_view returns before scene is ready otherwise)
	reward_scene.run_stats = run_stats
	reward_scene.current_party = current_party

	reward_scene.add_gold_reward(map.last_room.battle_stats.roll_gold_reward())
	reward_scene.add_shard_reward()


func _on_map_exited(room : Room) -> void:
	match room.type:
		Room.Type.MONSTER:
			_on_battle_room_entered(room)
		Room.Type.TREASURE:
			_change_view(LOOT_ROOM_SCENE)
		Room.Type.TOWN:
			_change_view(TOWN_SCENE)
		Room.Type.ELITE:
			_on_battle_room_entered(room) # TODO: might need to change later
		Room.Type.BOSS:
			_on_battle_room_entered(room) # TODO: might need to change later


func _on_party_menu_button_pressed() -> void:
	var menu_open := get_node_or_null("PartyMenu")
	if menu_open:
		menu_open.queue_free()
	else:
		var new_party_menu = PARTY_MENU_SCENE.instantiate()
		new_party_menu.name = "PartyMenu"
		add_child.call_deferred(new_party_menu)