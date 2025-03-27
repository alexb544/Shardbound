extends Node

@onready var party_spawns = %Party
@onready var party_box = %PartyList
@onready var stats : CharacterStats

var current_party : CurrentParty = preload("res://Resources/current_party.tres")
var party_list : Array = []
var party_members : Array = []


func _ready():
	party_list = current_party.get_party_list()
	spawn_party()
	set_partybox()


func spawn_party():
	var spawnpoints = party_spawns.get_children()

	for i in range(party_list.size()):
		if !party_list.is_empty():
			var member = party_list[i].instantiate()
			var point = spawnpoints[i] # gets next spawnpoint
			
			member.global_position = point.global_position
			add_child.call_deferred(member)
			party_members.append(member)
		else:
			pass


func set_partybox():
	var partyUI : Array = party_box.get_children()
	for party in partyUI:
		var info_boxes = party.get_children()
		
