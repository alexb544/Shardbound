class_name ShardPile
extends Resource

signal shard_pile_size_changed(shards_amount)

@export var shards : Array[Resource] = []


func empty() -> bool:
    return shards.is_empty()


func use_shard() -> Resource:
    var shard = shards.pop_front()
    shard_pile_size_changed.emit(shards.size())
    return shard


func add_shard(shard : Resource) -> void:
    shards.append(shard)
    shard_pile_size_changed.emit(shards.size())


func clear() -> void:
    shards.clear()
    shard_pile_size_changed.emit(shards.size())


func _to_string() -> String:
    var _shard_strings : PackedStringArray = []
    for i in range(shards.size()):
        _shard_strings.append("%s: %s" % [i+1, shards[i].id])
    return "\n".join(_shard_strings)