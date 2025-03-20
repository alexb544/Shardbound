extends Node

var battle_count : int = 1


func battle_fought():
    battle_count += 1


func reset_session():
    battle_count = 0