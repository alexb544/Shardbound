class_name Town
extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var party : CurrentParty = GlobalParty.current_party

var recruit_pool : Array[CharacterData] = Recruits.recruit_pool

func _on_inn_button_pressed() -> void:
	for unit in GlobalParty.current_party.party_members:
		if unit != null:
			var party_member = unit.scene.instantiate()
			party_member.stats.heal(ceili(party_member.stats.max_health * 0.30))
			party_member.stats.regen(ceili(party_member.stats.max_mana * 0.30))
			animation_player.play("fade_out")


func _on_recruit_button_pressed() -> void:
	if recruit_pool.size() > 0:
		var index = randi_range(0, recruit_pool.size() - 1)
		var selected_character = recruit_pool[index]

		GlobalParty.add_to_party(selected_character)
		recruit_pool.erase(selected_character)

		animation_player.play("fade_out")
	else:
		print("No more characters to add in pool")

# called from the AnimationPlayer at the end of 'fade_out'.
func _on_fade_out_finished() -> void:
	Events.town_exited.emit()
