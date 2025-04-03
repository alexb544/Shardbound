class_name StatsTooltipPopup
extends Control

const PARTY_PANEL_SCENE := preload("res://Scenes/ui/party_panel.tscn")

@onready var tooltip_stats : CenterContainer = %TooltipStats
@onready var stat_description : RichTextLabel = %StatsDescription


func _ready():
	for panel : PartyPanel in tooltip_stats.get_children():
		panel.queue_free()


func show_tooltip(stats : CharacterStats) -> void:
	var new_panel := PARTY_PANEL_SCENE.instantiate() as PartyPanel
	tooltip_stats.add_child(new_panel)
	new_panel.stats = stats
	new_panel.tooltip_requested.connect(hide_tooltip.unbind(1))
	stat_description.text = " STR: " + str(stats.strength) + "\n MAG: " + str(stats.magic) + "\n SPD: " + str(stats.speed)
	show()


func hide_tooltip() -> void:
	if not visible:
		return
	
	for stats : PartyPanel in tooltip_stats.get_children():
		stats.queue_free()

	hide()

func _on_gui_input(event:InputEvent) -> void:
	if event.is_action_pressed("left_mouse"):
		hide_tooltip()
