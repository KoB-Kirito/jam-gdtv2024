extends CharacterBody3D
class_name Enemy


@export var speed: float = 10.0

var target: Node3D


func _physics_process(delta: float) -> void:
	if global_position.distance_squared_to(target.global_position) > 1:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()
