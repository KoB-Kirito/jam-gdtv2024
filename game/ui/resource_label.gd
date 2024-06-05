extends Label


var last_value: int = 0


func _ready() -> void:
	Events.resource_changed.connect(on_resource_changed)


func on_resource_changed(value: int) -> void:
	text = str(value)
	
	if value > last_value:
		modulate = Color.GREEN
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.4)
		
	elif value < last_value:
		modulate = Color.RED
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 0.4)
	
	last_value = value
