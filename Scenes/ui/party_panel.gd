class_name PartyPanel
extends CenterContainer

signal tooltip_requested(stats : CharacterStats)

@export var party_member : CharacterStats : set = set_party_ui
@export var current_party : CurrentParty = preload("res://Resources/current_party.tres")

@onready var character_name : Label = %Name
@onready var sprite : AnimatedSprite2D = %Sprite

@onready var health : HBoxContainer = %Health
@onready var mana : HBoxContainer = %Mana
@onready var experience : HBoxContainer = %Experience

var stats : CharacterStats


func _on_visuals_gui_input(event : InputEvent) -> void:
	if event.is_action_pressed("mouse"):
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
