class_name Shard 
extends Resource

enum Type {ATTACK, HEAL} # 0 = Attack, 1 = Heal
enum Target {PARTY, ALL_PARTY, SINGLE_ENEMY, ALL_ENEMIES}

@export_group("Shard Attributes")
@export var id : String
@export var type : Type
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
    stats.current_mana -= mana

    if is_single_targeted():
        apply_effects(targets)
    else:
        apply_effects(_get_targets(targets))


func apply_effects(_targets : Array[Node]) -> void:
    pass
