class_name HealEffect
extends Effect

var amount := 0
var character : Character

func execute(targets: Array[Node]) -> void:
    for target in targets:
        if not target:
            continue
        if target.is_in_group("party_members"):
            target.stats.heal(amount)