class_name PartyManager
extends Node

@export var current_party : CurrentParty

@onready var party_spawns = %Party
@onready var party_container = %PartyList
@onready var stats : CharacterStats

var party_list : Array = []
var party_members : Array = []


func _ready():
	party_list = current_party.get_party_list()
	await spawn_party()
	await set_party_ui()


func spawn_party():
	var spawnpoints = party_spawns.get_children()

	for i in range(party_list.size()):
		var member = party_list[i].instantiate() as Character
		var point = spawnpoints[i] # gets next spawnpoint
			
		member.global_position = point.global_position
		add_child.call_deferred(member)
		party_members.append(member)



func set_party_ui():
	for i in range(party_container.get_child_count()): # PartyList -> (PM1, PM2, PM3, PM4) (4)
		var unit_ui = party_container.get_child(i)

		if i < party_members.size():
			var unit = party_members[i]
			var info = unit_ui.get_node("Info") # Info -> (Icon, HealthBar/Label, ManaBar/Label)

			# == Icon ==========================================================
			var icon = info.get_node("Icon") as TextureRect
			icon.texture = unit.stats.icon

			# == Health Bar ====================================================
			var health_bar = info.get_node("HealthBar") as TextureProgressBar
			health_bar.max_value = unit.stats.max_health
			health_bar.value = unit.stats.current_health

			var health_text = health_bar.get_node("Label") as Label
			health_text.text = str(unit.stats.current_health)

			unit.stats.health_changed.connect(Callable(self, "_on_health_changed").bind(health_bar, health_text))

			# == Mana Bar ======================================================
			var mana_bar = info.get_node("ManaBar") as TextureProgressBar
			mana_bar.max_value = unit.stats.max_mana
			mana_bar.value = unit.stats.current_mana

			var mana_text = mana_bar.get_node("Label") as Label
			mana_text.text = str(unit.stats.current_mana)

			unit.stats.mana_changed.connect(_on_mana_changed.bind(mana_bar, mana_text))

			unit_ui.visible = true
			
		else:
			unit_ui.visible = false # Hides UI elements if unused 



func _on_health_changed(value : int, health_bar : TextureProgressBar, health_text : Label):
	health_bar.value = value
	health_text.text = str(value)



func _on_mana_changed(value, mana_bar, mana_text):
	mana_bar.value = value
	mana_text.text = str(value)
