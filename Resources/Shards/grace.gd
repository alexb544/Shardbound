extends Shard

var grace_animation = preload("res://Scenes/shard_effects/grace_effect.tscn")

func apply_effects(targets : Array[Node]) -> void:
    var heal_effect := HealEffect.new()
    heal_effect.amount = 15
    heal_effect.execute(targets)

    var animations := []

    for t in targets:
        if not t:
            continue
        
        var scene = grace_animation.instantiate()
        t.add_child(scene)
        var animation_player : AnimationPlayer = scene.get_node("AnimationPlayer")
        animation_player.play("grace")
        animations.append(animation_player)
        #await animation_player.animation_finished
        #scene.queue_free()
    
    for animation_player in animations:
        await animation_player.animation_finished

    for animation_player in animations:
        animation_player.get_parent().queue_free()