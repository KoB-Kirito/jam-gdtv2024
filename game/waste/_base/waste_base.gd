extends CharacterBody3D
class_name Waste
## Base class for waste that falls down to the ground and can be collected


## Resource given by gathering this item
@export var value: int = 10

var life_time: float


func _ready() -> void:
	if life_time > 0:
		%LifetimeTimer.start(life_time)


func _physics_process(delta: float) -> void:
	if position.y <= 0:
		position.y = 0
		
	else:
		# apply gravity
		velocity = get_gravity()
		move_and_slide()


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse_input := event as InputEventMouseButton
	if mouse_input and mouse_input.is_pressed():
		if mouse_input.button_index == MOUSE_BUTTON_LEFT:
			print_debug("bottle input event")
			Events.waste_collected.emit(value)
			queue_free()


func _on_lifetime_timer_timeout() -> void:
	var tween = create_tween()
	
