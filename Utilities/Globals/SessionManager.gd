extends Node

var battle_count : int = 1

var gold : int = 100


func battle_fought():
	battle_count += 1


func reset_run():
	battle_count = 0
