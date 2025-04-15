class_name RunStats 
extends Resource

signal gold_changed
signal party_changed

const STARTING_GOLD := 100
const BASE_SHARD_REWARDS := 1
const STARTING_PARTY : CurrentParty = preload("res://Resources/new_party.tres")
# const PLAYER_DATA : CharacterData = preload("res://Resources/CharacterData/player_data.tres")

@export var gold := STARTING_GOLD : set = set_gold 
@export var shard_rewards := BASE_SHARD_REWARDS
@export var party := STARTING_PARTY
# @export var party_data := PLAYER_DATA : set = set_stats


func set_gold(new_amount : int) -> void:
	gold = new_amount
	gold_changed.emit()


func set_party(new_party : CurrentParty) -> void:
	party = new_party
	party_changed.emit()


func get_party() -> CurrentParty:
	return party


# func set_stats(new_party_data : CharacterData) -> void:
# 	party_data = new_party_data