class_name CharacterStats
extends Resource

signal health_changed(value)
signal mana_changed(value)

@export var name : String
@export var icon : Texture
@export var level : int

@export var max_health : int
@export var max_mana : int

@export var strength : int
@export var magic : int
@export var speed : int

var _current_health : int = max_health
var _current_mana : int = max_mana


var current_health : int:
	get:
		return _current_health
	set(value):
		_current_health = clamp(value, 0, max_health)
		health_changed.emit(_current_health)

var current_mana : int:
	get:
		return _current_mana
	set(value):
		_current_mana = clamp(value, 0, max_mana)
		mana_changed.emit(_current_mana)
