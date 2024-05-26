extends Node3D
## Displays the health of the owner as a healthbar


func _ready() -> void:
	if owner == null:
		push_error("HealthbarComponent has no owner")
		return
	if not owner.has_signal("health_changed"):
		push_error("HealthbarComponent owner has no health_changed signal: " + owner.scene_file_path)
		return
	
	owner.health_changed.connect(on_health_changed)


func on_health_changed(health: float) -> void:
	%HealthProgressBar.value = health / owner.max_health * 100
	%HealthProgressBar.tint_progress = Color(1 - health / owner.max_health, health / owner.max_health, 0)
