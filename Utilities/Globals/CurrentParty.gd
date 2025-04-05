extends Resource
class_name CurrentParty

@export var player : PackedScene
@export var party2 : PackedScene
@export var party3 : PackedScene
@export var party4 : PackedScene


func get_party_list() -> Array:
	var party_list : Array = []
	
	party_list.append(player)
	
	if party2 != null:
		party_list.append(party2)

	if party3 != null:
		party_list.append(party3)

	if party4 != null:
		party_list.append(party4)
	
	return party_list


#TODO: Add, Remove (on death), Dismiss
