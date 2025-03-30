extends Control

@onready var party_manager = $PartyManager
@onready var enemy_manager = $EnemyManager
@onready var combat_manager = $CombatManager


func _ready() -> void:
	SessionManager.battle_fought() # increments battle_count