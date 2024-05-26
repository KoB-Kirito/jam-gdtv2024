extends CharacterBody3D
class_name Enemy


signal health_changed(new_health: float)

@export var speed: float = 10.0
@export var max_health: float = 10
@onready var health: float = max_health:
	set(value):
		health = value
		health_changed.emit(health)

@export_group("Attack")
@export var damage: float = 1.0
@export var attack_range: float = 1.0
## Time it takes for the animation to "hit"
@export var attack_windup: float = 0.5
## Time after attack until it attacks again
@export var attack_cooldown: float = 2.0

var target: Node3D
var current_target: Node3D
var tower_in_range: Array[Tower]
var target_in_range: bool = false

var is_dead: bool = false


func _ready() -> void:
	assert(target, "target is not set")
	current_target = target
	
	Events.enemy_spawned.emit()
	%NavigationAgent3D.set_target_position(current_target.global_position)
	%NavigationAgent3D.velocity_computed.connect(Callable(_on_velocity_computed))


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		return
	
	if %NavigationAgent3D.is_navigation_finished():
		return
	
	# attack target if close enough
	if global_position.distance_to(current_target.global_position) < attack_range:
		if not target_in_range:
			target_in_range = true
			attack_current_target()
		return
	target_in_range = false
	
	# move to target
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


func _on_tower_detector_body_entered(body: Node3D) -> void:
	if body is Tower:
		tower_in_range.append(body)
		if current_target == target:
			current_target = body
			%NavigationAgent3D.set_target_position(current_target.global_position)


func _on_attack_windup_timer_timeout() -> void:
	# check target
	if not is_instance_valid(current_target):
		# get new target
		current_target = null
		target_in_range = false
		var to_remove: Array[int] = []
		for i in tower_in_range.size():
			if not is_instance_valid(tower_in_range[i]):
				to_remove.append(i)
				continue
			current_target = tower_in_range[i]
			break
		
		to_remove.reverse()
		for i in to_remove:
			tower_in_range.remove_at(i)
		
		# reset to default target if no tower is in range
		if current_target == null:
			current_target = target
		return
	
	#TODO: play hit sound
	current_target.take_damage(damage)
	%AttackCooldownTimer.start(attack_cooldown)


func _on_attack_cooldown_timer_timeout() -> void:
	attack_current_target()

func attack_current_target() -> void:
	#TODO: play animation
	%AttackWindupTimer.start(attack_windup)
