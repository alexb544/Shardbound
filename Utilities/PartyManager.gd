extends Node

var current_party : CurrentParty
var party_members : Array = []

func _ready():
	current_party = load("res://Resources/current_party.tres")
	
	if current_party:
		var party_list = current_party.get_party_list()
	
		for party_scene in party_list:
			if party_scene != null:
				var party_member = party_scene.instantiate()
				party_members.append(party_member)
				add_child.call_deferred(party_member)
			else:
				continue
