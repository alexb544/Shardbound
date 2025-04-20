class_name PartyMenu
extends CanvasLayer

@onready var party_menu : HBoxContainer = %Party
@onready var party_menu_ui : PartyPanel


func _ready():
	for i in range(party_menu.get_child_count()):

		if i < GlobalParty.current_party.party_members.size() and GlobalParty.current_party.party_members[i].stats != null:
			var stats = GlobalParty.current_party.party_members[i].stats
			var panel = party_menu.get_child(i)
			#var member = GlobalParty.current_party.party_members[i].scene.instantiate() as Character
			panel.set_party_ui(stats) # requesting stats

		else:
			party_menu.get_child(i).hide()
		

func _on_close_button_pressed() -> void:
	queue_free()
