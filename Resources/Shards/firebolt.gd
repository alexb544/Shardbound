extends Shard

var firebolt_animation = preload("res://Scenes/shard_effects/firebolt_effect.tscn")

func apply_effects(targets : Array[Node]) -> void:
    var damage_effect := FireEffect.new()
    damage_effect.amount = 20
    damage_effect.execute(targets)

    for t in targets:
        if not t:
            continue
        
        var scene = firebolt_animation.instantiate()
        t.add_child(scene)
        var animation_player : AnimationPlayer = scene.get_node("AnimationPlayer")
        animation_player.play("firebolt")
        await animation_player.animation_finished
        scene.queue_free()