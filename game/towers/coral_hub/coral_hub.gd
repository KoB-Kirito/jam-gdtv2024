extends Tower
class_name CoralHub


@export var max_connections: int = 3

var _connected_towers: Array[Tower] = []

var current_connections: int:
	get:
		return _connected_towers.size()
var free_connections: int:
	get:
		return max_connections - current_connections

var build_mode_active: bool = false


func _ready() -> void:
	#HACK: assume that build mode is still active if shift is pressed
	if not Input.is_key_pressed(KEY_SHIFT):
		build_mode_active = true
		%RangeIndicator.hide()
	Events.build_mode_entered.connect(on_build_mode_entered)
	Events.build_mode_exited.connect(on_build_mode_exited)


func on_build_mode_entered() -> void:
	build_mode_active = true
	if free_connections > 0:
		%RangeIndicator.mesh.surface_get_material(0).albedo_color = Color(0.0, 1.0, 0.0, 0.5)
		#%RangeIndicator.mesh.material.albedo_color = Color(0.0, 1.0, 0.0, 0.5)
	else:
		%RangeIndicator.mesh.surface_get_material(0).albedo_color = Color(1.0, 0.8, 0.0, 0.5)
		#%RangeIndicator.mesh.material.albedo_color = Color(1.0, 0.8, 0.0, 0.5)
	
	%RangeIndicator.show()


func on_build_mode_exited() -> void:
	build_mode_active = false
	%RangeIndicator.hide()


func connect_tower(tower: Tower) -> void:
	_connected_towers.append(tower)
	tower.died.connect(on_connected_tower_died.bind(tower))
	update_label()


func on_connected_tower_died(tower: Tower) -> void:
	_connected_towers.erase(tower)
	update_label()


func update_label() -> void:
	%ConnectionsLabel.text = str(current_connections) + " / " + str(max_connections)
	
	%ConnectionsLabel.visible = free_connections > 0
