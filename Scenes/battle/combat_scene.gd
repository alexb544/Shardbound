class_name Battle
extends Control

signal textbox_closed

@export var battle_stats : EnemyGroups

@onready var party_manager = $PartyManager
@onready var enemy_manager = $EnemyManager
@onready var combat_manager = $CombatManager
@onready var music_player : AudioStreamPlayer2D = %BattleMusic


func _ready() -> void:
	SessionManager.battle_fought() # increments battle_count
	$TextBox.hide()
	display_text("Battle Start!")
	start_battle()
	

func start_battle() -> void:
	if battle_stats.battle_tier < 2 or battle_stats.battle_tier == 4:
		music_player.stream = preload("res://Sounds/music/11-Fighting.mp3")
		music_player.play()
	
	if battle_stats.battle_tier == 2:
		music_player.stream = preload("res://Sounds/music/21-Still More Fighting.mp3")
		music_player.play()
		
	if battle_stats.battle_tier == 3: 
		music_player.stream = preload("res://Sounds/music/87-One-Winged Angel.mp3")
		music_player.play()


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $TextBox.is_visible_in_tree():
		$TextBox.hide()
		emit_signal("textbox_closed")


func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text
