extends StaticBody3D
class_name Tower


signal health_changed(new_health: float)
signal died

@export var can_be_damaged: bool = true

@export var max_health: float = 10.0
@onready var health: float = max_health


func _enter_tree() -> void:
	#HACK
	Events.build_phase_started.connect(_on_round_started)

func _on_round_started(duration: float) -> void:
	# heal when clam is activated #HACK
	if Globals.current_level >= 4:
		take_damage(-20.0)


func take_damage(amount: float) -> void:
	health -= amount
	if health > max_health:
		health = max_health
	health_changed.emit(health)
	if health <= 0:
		die()
		return


func die() -> void:
	#TODO: Animation, etc
	died.emit()
	queue_free()
