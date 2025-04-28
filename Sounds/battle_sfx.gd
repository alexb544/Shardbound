extends Node

@export var sound_effects : Array = []

var audio_player : AudioStreamPlayer

func _ready() -> void:
    audio_player = get_node("../SFX") 

    sound_effects = [
        preload("res://Sounds/sfx/players_turn.wav"),
        preload("res://Sounds/sfx/enemy_death.wav"),
        preload("res://Sounds/sfx/hit_sounds/se_cloud_final_swing03.wav"), # 1, 2, 3, 4 -> test to see which works best 
        preload("res://Sounds/sfx/hit_sounds/se_cloud_hit_m.wav") # l, m, s -> same for these
    ]


func play_sound(index : int, volume_db : float = -20): 
    if index >= 0 and index < sound_effects.size():
        if audio_player:
            audio_player.stream = sound_effects[index]
            audio_player.volume_db = volume_db
            audio_player.play()
        else: 
            print("audiostreamplayer is null!")
    else:
        print("Invalid sound effect index!")