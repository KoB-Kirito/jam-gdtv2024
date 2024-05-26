extends Node3D
class_name Tower


@export var max_health: float = 10.0
@onready var health: float = max_health


func take_damage(amount: float) -> void:
	health -= amount
	if health <= 0:
		die()
		return
	
	


func die() -> void:
	#TODO: Animation, etc
	queue_free()
