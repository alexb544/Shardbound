extends Node

signal health_changed(unit, new_health)
signal unit_died(unit)

func damage_taken(unit : Resource, amount : int):
	if unit == null:
		return
	unit.current_health = max(0, unit.current_health - amount)
	health_changed.emit(unit, unit.current_health)
	
	if unit.current_health == 0:
		unit_died.emit(unit)

func heal(unit : Resource, amount : int):
	if unit == null:
		return
	unit.current_health = min(unit.max_health, unit.current_health + amount)
	health_changed.emit(unit, unit.current_health)
