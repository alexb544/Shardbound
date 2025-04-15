class_name PartyManager
extends Node

@onready var party_spawns = %Party # spawnpoints
@onready var party_container = %PartyList # node to add party under

var current_party : CurrentParty = GlobalParty.current_party


func _ready():
	await spawn_party()
	await set_party_ui()


func spawn_party():
	var spawnpoints = party_spawns.get_children()
	var party_data = current_party.party_members

	for i in range(party_data.size()):
		var scene := party_data[i].scene.instantiate() as Character
		var character_stats : CharacterStats = party_data[i].stats
		scene.stats = character_stats
		
		scene.global_position = spawnpoints[i].global_position
		add_child.call_deferred(scene)
		


	# for i in range(current_party.party_members.size()):
	# 	var data : CharacterData = current_party.party_members[i] as CharacterData
	# 	var character : Character = data.scene.instantiate() as Character

	# 	character.stats = data.stats # run stats
	# 	character.global_position = spawnpoints[i].global_position

	# 	add_child.call_deferred(character)
	# 	party_members.append(character)


func set_party_ui():
	for i in range(party_container.get_child_count()): # PartyList -> (PM1, PM2, PM3, PM4) (4)
		var unit_ui = party_container.get_child(i)
		var party_data = current_party.party_members

		if i < party_data.size():
			var unit = current_party.party_members[i].stats
			var info = unit_ui.get_node("Info") # Info -> (Icon, HealthBar/Label, ManaBar/Label)

			# == Icon ==========================================================
			var icon = info.get_node("Icon") as TextureRect
			icon.texture = unit.icon

			# == Health Bar ====================================================
			var health_bar = info.get_node("HealthBar") as TextureProgressBar
			health_bar.max_value = unit.max_health
			health_bar.value = unit.current_health
			var health_text = health_bar.get_node("Label") as Label
			health_text.text = str(unit.current_health)
			unit.health_changed.connect(Callable(self, "_on_health_changed").bind(health_bar, health_text))

			# == Mana Bar ======================================================
			var mana_bar = info.get_node("ManaBar") as TextureProgressBar
			mana_bar.max_value = unit.max_mana
			mana_bar.value = unit.current_mana
			var mana_text = mana_bar.get_node("Label") as Label
			mana_text.text = str(unit.current_mana)
			unit.mana_changed.connect(Callable(self, "_on_mana_changed").bind(mana_bar, mana_text))

			unit_ui.visible = true
			
		else:
			unit_ui.visible = false # Hides UI elements if unused 


func setup_party(party : CurrentParty) -> void:
	current_party = party as CurrentParty
	await spawn_party()
	await set_party_ui()

func _on_health_changed(value : int, health_bar : TextureProgressBar, health_text : Label):
	health_bar.value = value
	health_text.text = str(value)


func _on_mana_changed(value, mana_bar, mana_text):
	mana_bar.value = value
	mana_text.text = str(value)
