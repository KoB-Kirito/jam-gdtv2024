extends StaticBody3D
class_name Tower


signal health_changed(new_health: float)
signal died

@export var can_be_damaged: bool = true

@export var max_health: float = 10.0
@onready var health: float = max_health


func take_damage(amount: float) -> void:
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		die()
		return


func die() -> void:
	#TODO: Animation, etc
	died.emit()
	queue_free()
