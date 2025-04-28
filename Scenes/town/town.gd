class_name Town
extends Control

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var rest_sound : AudioStreamPlayer2D = %RestSound
@onready var town_music : AudioStreamPlayer2D = %TownMusic

var party : CurrentParty = GlobalParty.current_party
var recruit_pool : Array[CharacterData] = Recruits.recruit_pool
var run_stats : RunStats


func _on_inn_button_pressed() -> void:
	for unit in GlobalParty.current_party.party_members:
		if unit != null:
			town_music.stop()
			rest_sound.stream = preload("res://Sounds/music/27-Good Night, Until Tomorrow!.mp3")
			rest_sound.play()
			var party_member = unit.scene.instantiate()
			party_member.stats.heal(ceili(party_member.stats.max_health * 0.50))
			party_member.stats.regen(ceili(party_member.stats.max_mana * 0.50))

			animation_player.play("fade_out") # exits town


func _on_recruit_button_pressed() -> void:
	if recruit_pool.size() > 0 and run_stats.gold >= 100 and party.party_members.size() < 4:
		var index = randi_range(0, recruit_pool.size() - 1)
		var selected_character = recruit_pool[index]

		GlobalParty.add_to_party(selected_character)
		recruit_pool.erase(selected_character)
		run_stats.gold -= 100

		animation_player.play("fade_out") # exits town

	else:
		print("Not enough gold or your party is already full!")

# called from the AnimationPlayer at the end of 'fade_out' animation.
func _on_fade_out_finished() -> void:
	if rest_sound.stream != null:
		await rest_sound.finished
	Events.town_exited.emit()
