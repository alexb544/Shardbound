extends Control


func _on_button_pressed() -> void:
	Events.loot_room_exited.emit()
