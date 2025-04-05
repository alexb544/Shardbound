extends Shard


func apply_effects(targets : Array[Node]) -> void:
    var damage_effect := FireEffect.new()
    damage_effect.amount = 20
    damage_effect.execute(targets)