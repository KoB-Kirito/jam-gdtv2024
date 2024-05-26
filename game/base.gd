extends Node3D


signal took_damage(amount)


func take_damage(amount: float) -> void:
	took_damage.emit(amount)
