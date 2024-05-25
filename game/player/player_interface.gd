extends Node
## Handles player inputs


var tower_is_placeable: bool = false


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var mouse_position_3d := get_mouse_position_on_terrain()
	#TODO: Check for entering units
	if mouse_position_3d < Vector3.INF: #and mouse_position_3d != %TowerPlacer.transform.origin:
		%TowerPlacer.transform.origin = mouse_position_3d
		%TowerPlacer.show()
		if %TowerPlacer.placement_check():
			tower_is_placeable = true
		else:
			tower_is_placeable = false
	else:
		tower_is_placeable = false


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
