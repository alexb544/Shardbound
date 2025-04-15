class_name Town
extends Control

#@export var party : CurrentParty = preload("res://Resources/current_party.tres") # array of character.gd 
@export var characters : Array[Character]

@onready var animation_player : AnimationPlayer = $AnimationPlayer
#@onready var character_stats : CharacterStats

var party : CurrentParty = GlobalParty.current_party


func _on_inn_button_pressed() -> void:
	for unit in GlobalParty.current_party.party_members:
		if unit != null:
			var party_member = unit.scene.instantiate()
			print("health before: ", unit.stats.current_health)
			party_member.stats.heal(ceili(party_member.stats.max_health * 0.30))
			print("health after: ", unit.stats.current_health)
			animation_player.play("fade_out")
	

# called from the AnimationPlayer at the end of 'fade_out'.
func _on_fade_out_finished() -> void:
	Events.town_exited.emit()


func _on_recruit_button_pressed() -> void:
	pass # Replace with function body.