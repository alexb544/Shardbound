extends Shard

var grace_animation = preload("res://Scenes/shard_effects/grace_effect.tscn")

func apply_effects(targets : Array[Node]) -> void:
    var heal_effect := HealEffect.new()
    heal_effect.amount = 15
    heal_effect.execute(targets)

    for t in targets:
        if not t:
            continue
        
        var scene = grace_animation.instantiate()
        t.add_child(scene)
        var animation_player : AnimationPlayer = scene.get_node("AnimationPlayer")
        animation_player.play("grace")
        await animation_player.animation_finished
        scene.queue_free()