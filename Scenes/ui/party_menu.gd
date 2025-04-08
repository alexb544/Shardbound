class_name PartyMenu
extends Control

@export var current_party : CurrentParty = preload("res://Resources/current_party.tres")

@onready var party_menu : GridContainer = %Party
@onready var party_menu_ui : PartyPanel

var stats : CharacterStats


func _ready():
	var party_list = current_party.get_party_list()

	for i in range(party_menu.get_child_count()):
		if i < party_list.size() and party_list[i] != null:
			var panel = party_menu.get_child(i)
			var unit = party_list[i].instantiate()
			panel.set_party_ui(unit.stats)
		else:
			party_menu.get_child(i).hide()
		

func _on_close_button_pressed() -> void:
	queue_free()