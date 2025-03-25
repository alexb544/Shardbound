extends Node
# might use for tracking: gold, random run info (areas visted, enemies fought, etc.)
var battle_count : int = 2


func battle_fought():
    battle_count += 1


func reset_session():
    battle_count = 0