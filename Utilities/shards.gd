class_name Shard
extends Resource

enum Type {STRENGTH, MAGIC, SUPPORT}
enum Attribute {FIRE, ICE, LIGHTNING, WIND, PHYSICAL, NATURE}
enum Target {SINGLE_ALLY, ALL_ALLIES, SINGLE_ENEMY, ALL_ENEMIES}

@export_group("Shard Attributes")
@export var ability_name : String
@export var type : Type
@export var attribute : Attribute
@export var target : Target

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY or Target.SINGLE_ALLY
