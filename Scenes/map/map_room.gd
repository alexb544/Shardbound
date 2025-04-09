class_name MapRoom
extends Area2D

signal selected(room : Room)

const ICONS := {
	Room.Type.NOT_ASSIGNED : [null, Vector2.ONE],
	Room.Type.MONSTER : [preload("res://Graphics/map/combat.png"), Vector2(0.4, 0.4)],
	Room.Type.TREASURE : [preload("res://Graphics/map/treasure.png"), Vector2(0.4, 0.4)], # adjust these values later
	Room.Type.TOWN : [preload("res://Graphics/map/town.png"), Vector2(0.4, 0.4)],
	Room.Type.ELITE : [preload("res://Graphics/map/combat_elite.png"), Vector2(0.4, 0.4)],
	Room.Type.BOSS : [preload("res://Graphics/map/combat_boss.png"), Vector2.ONE],
}

@onready var sprite_2d : Sprite2D = $Visuals/Sprite2D
@onready var line_2d : Line2D = $Visuals/Line2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

var available := false : set = set_available
var room : Room : set = set_room

# CODE TO TEST SCENE INDEPENDENTLY
# func _ready():
# 	var test_room := Room.new()
# 	test_room.type = Room.Type.TREASURE
# 	test_room.position = Vector2(100, 100)
# 	room = test_room

# 	await get_tree().create_timer(2).timeout
# 	available = true


func set_available(new_value : bool) -> void:
	available = new_value

	if available:
		animation_player.play("highlighted")
	elif not room.selected:
		animation_player.play("RESET")


func set_room(new_data : Room) -> void:
	room = new_data
	position = room.position
	line_2d.rotation_degrees = randi_range(0, 360) # see if i like or not
	sprite_2d.texture = ICONS[room.type][0]
	sprite_2d.scale = ICONS[room.type][1]


func show_selected() -> void:
	line_2d.modulate = Color.WEB_PURPLE # adjust later


func _on_input_event(_viewport : Node, event : InputEvent, _shape_idx : int) -> void:
	if not available or not event.is_action_pressed("left_mouse"):
		return

	room.selected = true
	animation_player.play("select")


# Called by the AnimationPlayer when the "select" animation finishes
func _on_map_room_selected() -> void:
	selected.emit(room)
