class_name StatsTooltipPopup
extends Control
# NOT WORKING
@onready var stat_description : RichTextLabel = %StatsDescription
@onready var background : ColorRect = %Background

func _ready():
	hide_tooltip()
	await get_tree().create_timer(1).timeout
	show_tooltip(preload("res://Resources/CharacterStats/player.tres"))


func show_tooltip(stats : CharacterStats) -> void:
	stat_description = RichTextLabel.new()
	background.add_child(stat_description)
	stat_description.bbcode_enabled = true
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
