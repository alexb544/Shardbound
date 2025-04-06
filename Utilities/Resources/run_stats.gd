class_name RunStats 
extends Resource

signal gold_changed

const STARTING_GOLD := 100
const BASE_SHARD_REWARDS := 2

@export var gold := STARTING_GOLD : set = set_gold 
@export var shard_rewards := BASE_SHARD_REWARDS


func set_gold(new_amount : int) -> void:
    gold = new_amount
    gold_changed.emit()


