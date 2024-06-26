extends Node


@export var spawn_interval_from: float = 0.5
@export var spawn_interval_to: float = 2.0
@export var life_time: float = 10.0
## Life time reduces at this rate * level
@export var per_level_reduction: float = 0.0
@export var spawn_area: Area3D
@export var waste_scenes: Array[PackedScene]

var children_count: int

var current_round: int


func _ready() -> void:
	Events.round_started.connect(func(level: int): current_round = level)
	children_count = spawn_area.get_child_count()


func start() -> void:
	%WasteSpawnTimer.start(randf_range(spawn_interval_from, spawn_interval_to))


func spawn_random_waste() -> void:
	#TODO: weighted pick
	var waste: Waste = waste_scenes.pick_random().instantiate()
	waste.position = get_random_spawn_point()
	waste.life_time = life_time + current_round * per_level_reduction
	
	waste.scale = Vector3(randf_range(1.2, 1.8), randf_range(1.2, 1.8), randf_range(1.2, 1.8))
	waste.rotate_y(randf_range(0.0, TAU))
	
	owner.add_child(waste)
	
	
	#print_debug("spawned waste")


func get_random_spawn_point() -> Vector3:
	# get random shape
	var shape: CollisionShape3D = spawn_area.get_child(randi_range(0, children_count - 1))
	var box: BoxShape3D = shape.shape
	
	# return random point inside that shape
	return Vector3((shape.position.x - box.size.x / 2) + randf_range(0, box.size.x),
			shape.position.y,
			(shape.position.z - box.size.z / 2) + randf_range(0, box.size.z))


func _on_waste_spawn_timer_timeout() -> void:
	spawn_random_waste()
	%WasteSpawnTimer.start(randf_range(spawn_interval_from, spawn_interval_to))
