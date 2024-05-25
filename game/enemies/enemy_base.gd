extends CharacterBody3D
class_name Enemy


@export var speed: float = 10.0
@export var health: float = 10

var target: Node3D
var is_dead: bool = false


func _ready() -> void:
	assert(target, "target is not set")
	
	Events.enemy_spawned.emit()
	%NavigationAgent3D.set_target_position(target.global_position)
	%NavigationAgent3D.velocity_computed.connect(Callable(_on_velocity_computed))


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		return
	
	if %NavigationAgent3D.is_navigation_finished():
		return
	
	var next_path_position: Vector3 = %NavigationAgent3D.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * speed
	if %NavigationAgent3D.avoidance_enabled:
		%NavigationAgent3D.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector3):
	velocity = safe_velocity
	move_and_slide()


func take_damage(amount: float) -> void:
	if is_dead:
		return
	
	health -= amount
	if health <= 0:
		is_dead = true
		die()

func die() -> void:
	#TODO: animation
	Events.enemy_died.emit()
	queue_free()
