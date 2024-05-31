extends CharacterBody3D
class_name Waste
## Base class for waste that falls down to the ground and can be collected


const FALL_TIME = 12.0

## Resource given by gathering this item
@export var value: int = 10

## Height above ground to start floating
@export_group("Floating")
@export_range(0.0, 2.0, 0.1) var float_height: float = 0.5
@export_range(0.0, 2.0, 0.1) var float_speed: float = 1.0
@export_range(0.1, 2.0, 0.1) var float_frequency: float = 0.5
@export_range(0.1, 2.0, 0.1) var float_amplitude: float = 0.5

var life_time: float

var state: int = 0 # 0=sinking, 1=floating, 2=dissolving

var time: float

var original_position: Vector3


func _ready() -> void:
	if life_time > 0:
		%LifetimeTimer.start(life_time + FALL_TIME)


func _physics_process(delta: float) -> void:
	match state:
		0: # sinking
			if position.y <= float_height:
				position.y = float_height
				state = 1
				original_position = position
				return
			
			velocity = get_gravity() / 2
			move_and_slide()
		
		1: # floating
			if float_speed:
				time += float_speed * delta
				position.y = original_position.y + sin(time * float_frequency) * float_amplitude


func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	var mouse_input := event as InputEventMouseButton
	if mouse_input and mouse_input.is_pressed():
		if mouse_input.button_index == MOUSE_BUTTON_LEFT:
			#print_debug("waste input event")
			Events.waste_collected.emit(value)
			queue_free()


func _on_lifetime_timer_timeout() -> void:
	state = 2
	var tween = create_tween()
	
	#TODO: dissolve instead
	tween.tween_property(self, "position:y", -2.0, 6.0)
	
	tween.tween_callback(func(): queue_free())
