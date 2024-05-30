@tool
extends Camera3D


@export var target: Node3D


func _physics_process(delta: float) -> void:
	if current and target != null:
		look_at(target.position)
