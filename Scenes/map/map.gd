class_name Map 
extends Node2D

const SCROLL_SPEED := 35
const MAP_ROOM = preload("res://Scenes/map/map_room.tscn")
const MAP_LINE = preload("res://Scenes/map/map_line.tscn")

@onready var map_generator : MapGenerator = $MapGenerator
@onready var lines : Node2D = %Lines
@onready var rooms : Node2D = %Rooms
@onready var visuals : Node2D = $Visuals
@onready var camera_2d : Camera2D = $Camera2D

var map_data : Array[Array]
var floors_climbed : int
var last_room : Room
var camera_edge_y : float

var dragging = false
var last_mouse_pos := Vector2.ZERO


func _ready() -> void:
	dragging = false
	camera_2d.make_current()
	camera_edge_y = MapGenerator.Y_DIST * (MapGenerator.FLOORS - 1)


func _process(_delta: float) -> void:
	if dragging:
		var mouse_pos = get_viewport().get_mouse_position()
		var delta_y = mouse_pos.y - last_mouse_pos.y
		camera_2d.position.y -= delta_y
		last_mouse_pos = mouse_pos


func _input(event : InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("scroll_up"):
		camera_2d.position.y -= SCROLL_SPEED
	elif event.is_action_pressed("scroll_down"):
		camera_2d.position.y += SCROLL_SPEED

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		last_mouse_pos = get_viewport().get_mouse_position()

	camera_2d.position.y = clamp(camera_2d.position.y, -camera_edge_y, 0)


func generate_new_map() -> void:
	floors_climbed = 0
	map_data = map_generator.generate_map()
	create_map()


func create_map() -> void:
	for current_floor : Array in map_data:
		for room : Room in current_floor:
			if room.next_rooms.size() > 0:
				_spawn_room(room)
	
	# Boss room has no next room but we need to spawn it
	var middle := floori(MapGenerator.MAP_WIDTH * 0.5)
	_spawn_room(map_data[MapGenerator.FLOORS - 1][middle])

	var map_width_pixels := MapGenerator.X_DIST * (MapGenerator.MAP_WIDTH - 1)
	visuals.position.x = (get_viewport_rect().size.x - map_width_pixels) / 2
	visuals.position.y = get_viewport_rect().size.y / 2


func unlock_floor(which_floor : int = floors_climbed) -> void:
	for map_room : MapRoom in rooms.get_children():
		if map_room.room.row == which_floor:
			map_room.available = true


func unlock_next_rooms() -> void:
	for map_room : MapRoom in rooms.get_children():
		if last_room.next_rooms.has(map_room.room):
			map_room.available = true


func show_map() -> void:
	show()
	camera_2d.enabled = true


func hide_map() -> void:
	hide()
	camera_2d.enabled = false


func _spawn_room(room : Room) -> void:
	var new_map_room := MAP_ROOM.instantiate() as MapRoom
	rooms.add_child(new_map_room)
	new_map_room.room = room
	new_map_room.selected.connect(_on_map_room_selected)
	_connect_lines(room)

	if room.selected and room.row < floors_climbed:
		new_map_room.show_selected()


func _connect_lines(room : Room) -> void:
	if room.next_rooms.is_empty():
		return

	for next : Room in room.next_rooms:
		var new_map_line := MAP_LINE.instantiate() as Line2D
		new_map_line.add_point(room.position)
		new_map_line.add_point(next.position)
		lines.add_child(new_map_line)

	
func _on_map_room_selected(room : Room) -> void:
	for map_room : MapRoom in rooms.get_children():
		if map_room.room.row == room.row:
			map_room.available = false
	
	last_room = room
	floors_climbed += 1
	Events.map_exited.emit(room)
