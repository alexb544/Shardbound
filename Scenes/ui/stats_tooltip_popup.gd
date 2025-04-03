class_name StatsTooltipPopup
extends Control

# const PARTY_MENU_SCENE := preload("res://Scenes/ui/party_menu.tscn")

# @onready var tooltip : CenterContainer = %Tooltip
# @onready var stats_description : RichTextLabel = %StatDescription


# func _ready():
#     for party : CharacterStats in tooltip.get_children():
#         party.queue_free()
    
#     hide_tooltip()
#     await get_tree().create_timer(3.0).timeout
#     show_tooltip(preload("res://Resources/Characters/player.tres"))


# func show_tooltip(stats : CharacterStats) -> void:
#     var new_stats := PARTY_MENU_SCENE.instantiate() as PartyPanel
#     tooltip.add_child(new_stats)
#     new_stats.stats = stats

#func _on_gui_input(event:InputEvent) -> void:
#	pass # Replace with function body.
