class_name PartySelector
extends CanvasLayer

@onready var party_data_list : Array[CharacterData] = GlobalParty.current_party.party_members

@onready var party_menu : HBoxContainer = %Party
@onready var party_menu_ui : PartySelectorPanel

func _ready():
	for i in range(party_menu.get_child_count()):
		var panel = party_menu.get_child(i)

		if i < party_data_list.size() and party_data_list != null:
			var character = party_data_list[i].scene.instantiate()
			if panel is PartySelectorPanel:
				panel.set_party_ui(character)
				panel.shard_selected.connect(_on_shard_selected)
				panel.show()
		else:
			party_menu.get_child(i).hide()


func _on_shard_selected() -> void:
	queue_free()