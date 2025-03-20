extends Resource
class_name CurrentParty

const PLAYER : PackedScene = preload("res://Scenes/Characters/player.tscn")
@export var party2 : PackedScene
@export var party3 : PackedScene
@export var party4 : PackedScene

func get_party_list() -> Array[PackedScene]:
	var party_list = [PLAYER, party2, party3, party4]
	return party_list


#TODO: Add, Remove (on death), Dismiss
