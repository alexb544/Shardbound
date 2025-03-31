extends Control

const RUN_SCENE = preload("res://Scenes/run/run.tscn")

@export var run_startup : RunStartup

@onready var continue_button : Button = %Continue # need to access diabled property later


func _ready():
	get_tree().paused = false


func _on_continue_pressed() -> void:
	print("continue run")


func _on_new_run_pressed() -> void:
	# add in transition later
	run_startup.type = RunStartup.Type.NEW_RUN
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_exit_game_pressed() -> void:
	get_tree().quit()