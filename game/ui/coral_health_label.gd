extends Label


func _ready() -> void:
	Events.coral_health_changed.connect(on_coral_health_changed)


func on_coral_health_changed(new_health: int) -> void:
	text = "Coral Health: " + str(new_health)
