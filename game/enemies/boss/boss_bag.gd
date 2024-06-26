extends Enemy


@export var enemies: Array[PackedScene]

@onready var coral: StaticBody3D = get_tree().get_first_node_in_group("coral")


func _on_spawn_timer_timeout() -> void:
	assert(coral)
	%AnimationPlayer.play("spawn")
	
	for i in randi_range(4, 12):
		var enemy: Enemy = enemies.pick_random().instantiate()
		enemy.main_target = coral
		
		get_parent().add_child(enemy)
		enemy.global_position = %SpawnPosition.global_position
		
		var tween = enemy.create_tween()
		tween.tween_property(enemy, "position:y", 10.0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(enemy, "position:y", 0.0, 2.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
		
		await get_tree().create_timer(0.4).timeout
	
	%SpawnTimer.start(randf_range(4.0, 8.0))
