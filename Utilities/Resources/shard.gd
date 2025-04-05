class_name Shard 
extends Resource

enum Type {ATTACK, HEAL}
enum Target {PARTY, ALL_PARTY, SINGLE_ENEMY, ALL_ENEMIES}
enum Rarity {COMMON, UNCOMMON, RARE}

const RARITY_COLORS := {
    Shard.Rarity.COMMON: Color.GRAY,
    Shard.Rarity.UNCOMMON: Color.CORNFLOWER_BLUE,
    Shard.Rarity.RARE: Color.GOLD
}

@export_group("Shard Attributes")
@export var id : String
@export var type : Type
@export var rarity : Rarity
@export var target : Target
@export var mana : int

@export_group("Shard Visuals")
@export var icon : Texture
@export_multiline var description : String
@export var sfx : AudioStream


func is_single_targeted() -> bool:
    return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
    if not targets:
        return []
    
    var tree := targets[0].get_tree()

    match target:
        Target.PARTY:
            return tree.get_nodes_in_group("party_members")
        Target.ALL_PARTY:
            return tree.get_nodes_in_group("party_members")
        Target.ALL_ENEMIES:
            return tree.get_nodes_in_group("enemies")
        _:
            return []


func play(targets : Array[Node], stats : CharacterStats) -> void:
    Events.shard_used.emit(self)
    stats.mana_changed.emit(mana)

    if is_single_targeted():
        apply_effects(targets)
    else:
        apply_effects(_get_targets(targets))


func apply_effects(_targets : Array[Node]) -> void:
    pass
