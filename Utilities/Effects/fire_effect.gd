class_name FireEffect
extends Effect

var amount := 0
var character : Character

func execute(targets: Array[Node]) -> void:
    for target in targets:
        if not target:
            continue

        if target.is_in_group("enemies"):
            target.stats.take_damage(amount)
