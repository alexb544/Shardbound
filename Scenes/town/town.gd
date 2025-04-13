class_name Town
extends Control

@export var party : CurrentParty = preload("res://Resources/current_party.tres")
@export var characters : Array[Character]

@onready var animation_player : AnimationPlayer = $AnimationPlayer
#@onready var character_stats : CharacterStats


func _on_recruit_button_pressed() -> void:
	pass # Replace with function body.


func _on_inn_button_pressed() -> void:
	for unit in party.get_party_list():
		if unit != null:
			var party_member = unit.instantiate()
			print("Health Before: ", party_member.stats.current_health)
			party_member.stats.heal(ceili(party_member.stats.max_health + 30))
			print("Health After: ", party_member.stats.current_health)
			animation_player.play("fade_out")
			# play a "resting" music/sound 
	
# called from the AnimationPlayer at the end of 'fade_out'.
func _on_fade_out_finished() -> void:
	Events.town_exited.emit()
