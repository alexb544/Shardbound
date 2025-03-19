extends Node

signal health_changed(unit, new_health)
signal unit_died(unit)

var combat_total : int = 0 # counts how many combats the player has taken

func damage_taken(unit : Resource, amount : int):
	if amount < unit.current_health:
		unit.current_health = unit.current_health - amount
		health_changed.emit(unit, unit.current_health)
	else: 
		unit.current_health = 0
		health_changed.emit(unit, unit.current_health)
		unit_died.emit(unit)

func heal(unit : Resource, amount : int):
	unit.current_health = unit.current_health + amount
	if unit.current_health > unit.max_health:
		unit.current_health = unit.max_health
	health_changed.emit(unit, unit.current_health)

func battle_scaling(): # Increases enemy count, based on how many battles the player has fought.
	if combat_total < 4:
		combat_total += 1
