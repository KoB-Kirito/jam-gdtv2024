extends CharacterBody3D
class_name Enemy


@export var speed: float = 10.0
@export var health: float = 10

var target: Node3D
var is_dead: bool = false


func _ready() -> void:
	Events.enemy_spawned.emit()


func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	# placeholder movement
	if global_position.distance_squared_to(target.global_position) > 1:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * speed
	else:
		velocity = Vector3.ZERO
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
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
