class_name CharacterStats
extends Resource

signal health_changed(value : int)
signal mana_changed(value)
signal stats_changed

@export var name : String
@export var icon : Texture
@export var level : int
@export var experience : int 

@export var max_health : int
@export var max_mana : int

@export var strength : int
@export var magic : int
@export var speed : int

@export var sprite : SpriteFrames

var current_health : int = max_health: 
	set(value):
		current_health = clampi(value, 0, max_health)
		health_changed.emit(current_health)
		stats_changed.emit()

var current_mana : int = max_mana:
	set(value):
		current_mana = clampi(value, 0, max_mana)
		mana_changed.emit(current_mana)
		stats_changed.emit()


func take_damage(damage : int) -> void:
	current_health -= damage
		

func heal(amount : int) -> void:
	current_health += amount


func regen(amount : int) -> void:
	current_mana += amount