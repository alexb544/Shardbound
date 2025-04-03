class_name PartyPanel
extends CenterContainer

signal tooltip_requested(stats : CharacterStats)

@export var party_member : CharacterStats : set = set_party_ui
@export var current_party : CurrentParty = preload("res://Resources/current_party.tres")

@onready var character_name : Label = %Name
@onready var sprite : AnimatedSprite2D = %Sprite
@onready var level : Label = %Level 

@onready var health : HBoxContainer = %Health
@onready var mana : HBoxContainer = %Mana
@onready var experience : HBoxContainer = %Experience

var stats : CharacterStats


func _on_visuals_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		tooltip_requested.emit(stats)


func _on_visuals_mouse_entered() -> void:
	# set style for panel on hover
	pass


func _on_visuals_mouse_exited() -> void:
	# set style for panel on hover-exited
	pass 


func set_party_ui(unit : CharacterStats) -> void:
	if not is_node_ready():
		await ready

	party_member = unit
	sprite.play("default")
	character_name.text = party_member.name
	level.text = "LVL " + str(party_member.level)

	# Health Bar:
	var health_bar : ProgressBar = health.get_child(1)
	health_bar.max_value = party_member.max_health
	health_bar.value = party_member.current_health
	var health_label : Label = health_bar.get_child(0)
	health_label.text = str(party_member.current_health) + "/" + str(party_member.max_health)

	# Mana Bar:
	var mana_bar : ProgressBar = mana.get_child(1)
	mana_bar.max_value = party_member.max_mana
	mana_bar.value = party_member.current_mana
	var mana_label : Label = mana_bar.get_child(0)
	mana_label.text = str(party_member.current_mana) + "/" + str(party_member.max_mana)

	# Experience Bar:
	var experience_bar : ProgressBar = experience.get_child(1)
	#experience_bar.max_value = party_member.next_level 	# Add in later
	experience_bar.value = party_member.experience
	var experience_label : Label = experience_bar.get_child(0)
	experience_label.text = str(party_member.experience) #+ "/" + str(party_member.next_level)


	