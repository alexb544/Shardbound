class_name CurrentParty
extends Resource

@export var party_members : Array[CharacterData] = []


func get_party_stats() -> Array[CharacterStats]:
	return party_members.map(func(data): return data.stats) # (lambda function, takes CharacterData as input -> returns stats)


func get_party_scenes() -> Array[PackedScene]: 
	return party_members.map(func(data): return data.scene)
