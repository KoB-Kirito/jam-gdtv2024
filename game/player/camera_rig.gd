extends Node3D


@export_group("Move")
@export var can_move: bool = true
@export_range(0, 100, 1) var move_speed: float = 60.0

@export_group("Pan")
@export var can_pan: bool = true
@export_range(0, 100, 1) var pan_margin: float = 60.0
@export_range(0, 20, 0.5) var pan_speed: float = 60.0

@export_group("Zoom")
@export var can_zoom: bool = true
@export_range(0, 100, 1) var zoom_minimum: float = 10.0
@export_range(0, 100, 1) var zoom_maximum: float = 25.0
@export_range(0, 10, 0.5) var zoom_step: float = 5.0
@export_range(0, 10, 0.5) var zoom_speed: float = 5
var zoom_target: float

@export_group("Rotate")
@export var can_rotate: bool = true
@export_range(0, 90, 1) var rotate_step: float = 15.0



func _ready() -> void:
	zoom_target = zoom_maximum
	%Tilt.position = Vector3(0, zoom_target, zoom_target)


func _process(delta: float) -> void:
	move_base(delta)
	automatic_pan(delta)
	zoom(delta)


func _unhandled_input(event: InputEvent) -> void:
	# zoom
	if event.is_action("camera_zoom_in"):
		zoom_target = clampf(zoom_target - zoom_step, zoom_minimum, zoom_maximum) 
	elif event.is_action("camera_zoom_out"):
		zoom_target = clampf(zoom_target + zoom_step, zoom_minimum, zoom_maximum)
	
	# rotate
	#TODO


func move_base(delta: float) -> void:
	if not can_move:
		return
	
	var direction := Input.get_vector("camera_left", "camera_right", "camera_forward", "camera_backward")
	var direction_3d := Vector3(direction.x, 0, direction.y) # project on plane
	position += direction_3d * move_speed * delta


func zoom(delta: float) -> void:
	if not can_zoom:
		return
	
	%Tilt.position = %Tilt.position.lerp(Vector3(0, zoom_target, zoom_target), zoom_speed / 50.0)


func automatic_pan(delta: float) -> void:
	if not can_pan:
		return
	
	var viewport: Viewport = get_viewport()
	var viewport_rect: Rect2 = viewport.get_visible_rect()
	var current_mouse_position: Vector2 = viewport.get_mouse_position()
	
	var pan_direction := Vector2.ZERO
	
	if current_mouse_position.x < pan_margin:
		# left 
		pan_direction.x = - get_relative_strength(current_mouse_position.x)
		
	elif current_mouse_position.x > viewport_rect.size.x - pan_margin:
		# right
		pan_direction.x = get_relative_strength(viewport_rect.size.x - current_mouse_position.x)
	
	if current_mouse_position.y < pan_margin:
		# up
		pan_direction.y = - get_relative_strength(current_mouse_position.y)
		
	elif current_mouse_position.y > viewport_rect.size.y - pan_margin:
		# down
		pan_direction.y = get_relative_strength(viewport_rect.size.y - current_mouse_position.y)
	
	if pan_direction:
		position += Vector3(pan_direction.x, 0, pan_direction.y) * pan_speed * delta


func get_relative_strength(distance_to_edge: float) -> float:
	var clamped_distance := clampf(distance_to_edge, 0, pan_margin)
	
	if is_zero_approx(clamped_distance):
		return 1.0
	
	return 1.0 - clamped_distance / pan_margin