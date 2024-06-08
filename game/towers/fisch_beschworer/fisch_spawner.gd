extends Tower
class_name FischSpawner


@export_range(0.1, 30.0, 0.1) var spawn_rate: float = 10.0
@export var spawn_scene: PackedScene

var spawns: Array[Spawn]
var enemies_in_range: Array[Enemy] = []

var current_target: Enemy:
	set(value):
		current_target = value
		# update target spawns
		for spawn in spawns:
			if is_instance_valid(spawn):
				#TODO: remove dead spawns
				spawn.current_target = current_target


func _ready() -> void:
	_spawn()
	%SpawnTimer.start(spawn_rate)


func _spawn() -> void:
	assert(spawn_scene, "No spawn scene assigned!")
	
	var spawn: Spawn = spawn_scene.instantiate()
	add_child(spawn)
	spawn.global_position = %Spawnpoint.global_position
	spawn.spawn_position = %Spawnpoint.global_position
	spawn.get_new_wander_target()
	
	spawn.current_target = current_target
	spawns.append(spawn)


func _on_spawn_timer_timeout() -> void:
	_spawn()


func _on_patrol_zone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)
		
		# Gegner hinzufügen
		if current_target == null:
			current_target = body


func _on_patrol_zone_body_exited(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.erase(body)
		
		if body == current_target:
			# get new enemy
			if enemies_in_range:
				current_target = enemies_in_range[0]
			else:
				current_target = null
