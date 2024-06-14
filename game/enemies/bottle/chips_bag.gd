extends Enemy
class_name ChipsBag


@export var nacho_scene: PackedScene
@export var nacho_amount: int = 3

@onready var coral: StaticBody3D = get_tree().get_first_node_in_group("coral")


func die() -> void:
	#TODO: animation
	Events.enemy_died.emit()
	
	for i in nacho_amount:
		var nacho: Enemy = nacho_scene.instantiate()
		nacho.main_target = coral
		get_parent().add_child(nacho)
		nacho.global_position = %SpawnPosition.global_position + Vector3(i - 1, 0, 0)
	
	await get_tree().create_timer(0.2).timeout
	
	queue_free()
