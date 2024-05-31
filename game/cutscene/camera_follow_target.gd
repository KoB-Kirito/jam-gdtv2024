@tool
extends Camera3D


## Camera will look_at this target while active
@export var target: Node3D


func _physics_process(delta: float) -> void:
	if current and target != null:
		look_at(target.global_position)
