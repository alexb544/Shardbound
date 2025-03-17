class_name PartyMembers # Stores current units in the player's party
extends Resource

@export var party1 : PackedScene = preload("res://Scenes/characters/player.tscn")
@export var party2 : PackedScene
@export var party3 : PackedScene 
@export var party4 : PackedScene


func getPartyList() -> Array:
	var partyArray = [party1, party2, party3, party4]
	return partyArray

func party_limit():
	pass
