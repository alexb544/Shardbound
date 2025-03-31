extends Resource
class_name CurrentParty

@export var player : PackedScene = preload("res://Scenes/Characters/player.tscn")
@export var party2 : PackedScene
@export var party3 : PackedScene
@export var party4 : PackedScene


func get_party_list() -> Array:
	var current_party : CurrentParty = load("res://Resources/current_party.tres")
	var party_list : Array = []
	
	party_list.append(player)
	
	if current_party.party2 != null:
		party_list.append(current_party.party2)

	if current_party.party3 != null:
		party_list.append(current_party.party3)

	if current_party.party4 != null:
		party_list.append(current_party.party4)
	
	return party_list


#TODO: Add, Remove (on death), Dismiss
