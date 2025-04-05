extends Control

signal textbox_closed

@onready var party_manager = $PartyManager
@onready var enemy_manager = $EnemyManager
@onready var combat_manager = $CombatManager


func _ready() -> void:
	SessionManager.battle_fought() # increments battle_count
	$TextBox.hide()
	display_text("Battle Start!")
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("confirm") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and $TextBox.is_visible_in_tree():
		$TextBox.hide()
		emit_signal("textbox_closed")


func display_text(text):
	$TextBox.show()
	$TextBox/Label.text = text
