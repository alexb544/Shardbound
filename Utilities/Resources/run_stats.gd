class_name RunStats 
extends Resource

signal gold_changed
signal party_changed

const STARTING_GOLD := 100
const BASE_SHARD_REWARDS := 1
const STARTING_PARTY := preload("res://Resources/current_party.tres")

@export var gold := STARTING_GOLD : set = set_gold 
@export var shard_rewards := BASE_SHARD_REWARDS
@export var current_party := STARTING_PARTY : set = set_new_party

func set_gold(new_amount : int) -> void:
    gold = new_amount # should be "+=" ?
    gold_changed.emit()


func set_party(run_party : CurrentParty) -> CurrentParty:
    run_party = CurrentParty.new()
    run_party.player = preload("res://Scenes/Characters/player.tscn")
    return run_party


func set_new_party(run_party : CurrentParty):
    run_party = CurrentParty.new()
    run_party.player = preload("res://Scenes/Characters/player.tscn")
    return run_party