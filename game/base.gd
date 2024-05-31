extends Node3D
## Makes the coral attackable
#TODO: move to health component


signal took_damage(amount)


func take_damage(amount: float) -> void:
	took_damage.emit(amount)
