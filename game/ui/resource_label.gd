extends Label


func _ready() -> void:
	Events.resource_changed.connect(on_resource_changed)


func on_resource_changed(value: int) -> void:
	text = str(Globals.resource)
