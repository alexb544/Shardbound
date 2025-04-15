extends Control

const RUN_SCENE = preload("res://Scenes/run/run.tscn")
const NEW_PARTY = preload("res://Resources/new_party.tres")

@export var run_startup : RunStartup

@onready var continue_button : Button = %Continue # need to access diabled property later

var current_party : CurrentParty : set = set_current_party


func _ready():
	set_current_party(NEW_PARTY)


func set_current_party(new_party : CurrentParty) -> void:
	current_party = new_party


func _on_continue_pressed() -> void:
	print("continue run")


func _on_new_run_pressed() -> void:
	run_startup.type = RunStartup.Type.NEW_RUN
	#run_startup.current_party = current_party
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_exit_game_pressed() -> void:
	get_tree().quit()
