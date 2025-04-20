class_name PartySelectorPanel
extends CenterContainer

signal shard_selected

@export var party_member : Character : set = set_party_ui

@onready var character_name : Label = %Name
@onready var sprite : AnimatedSprite2D = %Sprite
@onready var shard_list : RichTextLabel = %ShardList

var shard_to_select : Resource

func set_party_ui(unit : Character) -> void:
	if not is_node_ready():
		await ready
	await get_tree().process_frame

	party_member = unit
	sprite.sprite_frames = party_member.stats.sprite
	sprite.play("default")
	character_name.text = party_member.stats.name

	set_shard_list(unit)


func set_shard_list(unit : Character) -> void:
	shard_list.clear()
	shard_list.push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)

	var shards = unit.get_shards()
	if shards.size() == 0:
		shard_list.add_text("\n\n")
		return

	for shard in shards:
		if shard == null:
			continue
		shard_list.add_text(" ")
		shard_list.add_image(shard.icon, 20, 20)
		shard_list.append_text(shard.id + "\n")
		
	shard_list.pop()


func _on_select_button_pressed() -> void:
	if party_member == null:
		return

	if party_member.get_shards().size() >= 2:
		print("This character holds too many shards!")
		return
	
	if shard_to_select:
		party_member.shard_pile.add_shard(shard_to_select)
		emit_signal("shard_selected")


func set_shard_to_select(shard : Resource) -> void:
	shard_to_select = shard