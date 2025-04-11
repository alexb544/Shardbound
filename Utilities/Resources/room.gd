class_name Room
extends Resource

enum Type {NOT_ASSIGNED, MONSTER, TREASURE, TOWN, ELITE, BOSS}

@export var type : Type
@export var row : int
@export var column : int
@export var position : Vector2
@export var next_rooms : Array[Room]
@export var selected := false

@export var battle_stats : EnemyGroups