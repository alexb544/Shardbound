class_name StatsTooltipPopup
extends Control

@onready var stat_description : RichTextLabel = %StatsDescription


func _ready():
	hide_tooltip()
	await get_tree().create_timer(1).timeout
	show_tooltip(preload("res://Resources/Characters/ishil.tres"))


func show_tooltip(stats : CharacterStats) -> void:
	stat_description = RichTextLabel.new()
	stat_description.text = " " + str(stats.strength) + "\n " + str(stats.magic) + "\n SPD: " + str(stats.speed)
	add_child(stat_description)
	show()


func hide_tooltip() -> void:
	if not visible:
		return

	if stat_description:
		stat_description.queue_free()
		stat_description = null

	hide()

func _on_gui_input(event:InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()
