class_name CurrentParty
extends CharacterStats # changed from "Resource"

signal party_changed

const PLAYER_SCENE : PackedScene = preload("res://Scenes/Characters/player.tscn")

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


func create_new_party() -> CurrentParty:
	var new_party := CurrentParty.new()
	new_party.player = PLAYER_SCENE
	return new_party