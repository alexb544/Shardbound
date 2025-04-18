extends Node

var current_party : CurrentParty = null


func new_party_run():
	current_party = load("res://Resources/new_party.tres").duplicate()
	current_party.party_members[0].stats.current_health = current_party.party_members[0].stats.max_health
	current_party.party_members[0].stats.current_mana = current_party.party_members[0].stats.max_mana


func get_party_data() -> Array[CharacterData]:
	return current_party.party_members


func get_specific_party_stat(i : int) -> CharacterStats:
	return current_party.party_members[i].stats


func get_specific_party_scene(i : int) -> PackedScene:
	return current_party.party_members[i].scene


func add_to_party(party_data : CharacterData) -> void:
	if current_party.party_members.size() < 4:
		current_party.party_members.append(party_data)
		current_party.party_members[current_party.party_members.size() - 1].stats.current_health = current_party.party_members[current_party.party_members.size() - 1].stats.max_health
		current_party.party_members[current_party.party_members.size() - 1].stats.current_mana = current_party.party_members[current_party.party_members.size() - 1].stats.max_mana
	else:
		print("Not enough room in your party!")


func end_run(): # call when player wins/dies
	current_party = null
