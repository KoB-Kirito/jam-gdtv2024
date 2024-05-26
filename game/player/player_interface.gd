extends Node
## Handles player inputs


const GREEN = Color("00cc00a2")
const RED = Color("cc0000a2")


var current_tower: TowerData
var tower_preview: TowerPreview

var tower_is_placeable: bool = false:
	set(value):
		if value != tower_is_placeable:
			tower_is_placeable = value
			if tower_is_placeable:
				RenderingServer.global_shader_parameter_set("preview_color", GREEN)
			else:
				RenderingServer.global_shader_parameter_set("preview_color", RED)


func _ready() -> void:
	Events.ui_tower_selected.connect(on_tower_selected)


func _physics_process(delta: float) -> void:
	if current_tower == null or tower_preview == null:
		return
	
	var mouse_position_3d := get_mouse_position_on_terrain()
	
	#TODO: Check for entering units
	
	if mouse_position_3d < Vector3.INF: #and mouse_position_3d != tower_preview.transform.origin:
		tower_preview.transform.origin = mouse_position_3d
		if tower_preview.check_placement():
			tower_is_placeable = true
		else:
			tower_is_placeable = false
	else:
		tower_is_placeable = false


func _unhandled_input(event: InputEvent) -> void:
	var mouse_button_event := event as InputEventMouseButton
	if mouse_button_event and mouse_button_event.is_pressed():
		if mouse_button_event.button_index == MOUSE_BUTTON_LEFT:
			# left click
			print("left click")
			if tower_is_placeable:
				place_tower()


func place_tower() -> void:
	var location = tower_preview.global_position
	
	tower_preview.queue_free()
	tower_preview = null
	
	var tower: Tower = current_tower.scene.instantiate()
	current_tower = null
	
	add_child(tower)
	tower.global_position = location
	
	tower_is_placeable = false



func on_tower_selected(tower: TowerData) -> void:
	if tower_preview != null:
		tower_preview.queue_free()
		tower_preview = null
	
	current_tower = tower
	tower_preview = current_tower.preview_scene.instantiate()
	add_child(tower_preview)


## Returns the mouse position projected on terrain in 3d space, or Vector3.INF if not on terrain
func get_mouse_position_on_terrain() -> Vector3:
	var viewport: Viewport = get_viewport()
	var mouse_pos: Vector2 = viewport.get_mouse_position()
	var camera: Camera3D = viewport.get_camera_3d()
	
	var ray_from: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_to: Vector3 = ray_from + camera.project_ray_normal(mouse_pos) * 1000.0
	var ray_param := PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	ray_param.collision_mask = 2
	
	var raycast_result := camera.get_world_3d().get_direct_space_state().intersect_ray(ray_param)
	if raycast_result:
		return raycast_result.position
	else:
		return Vector3.INF
