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
@export var attack_range: float = 1.5
## Time it takes for the animation to "hit"
@export var attack_windup: float = 0.5
## Time after attack until it attacks again
@export var attack_cooldown: float = 2.0

var target: Node3D
var current_target: Node3D
var towers_in_range: Array[Node3D]
var target_in_range: bool = false

var is_dead: bool = false

var last_position: Vector3


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
	
	# check target
	if not is_instance_valid(current_target):
		# get new target
		current_target = null
		target_in_range = false
		var to_remove: Array[int] = []
		for i in towers_in_range.size():
			if not is_instance_valid(towers_in_range[i]):
				to_remove.append(i)
				continue
			current_target = towers_in_range[i]
			break
		
		to_remove.reverse()
		for i in to_remove:
			towers_in_range.remove_at(i)
		
		# reset to default target if no tower is in range
		if current_target == null:
			current_target = target
		
		%NavigationAgent3D.set_target_position(current_target.global_position)
	
	# don't move if attacking
	if target_in_range:
		return
	
	# fallback
	if global_position.distance_to(current_target.global_position) < attack_range:
		target_in_range = true
		attack_current_target()
		return
	
	# move to target
	var next_path_position: Vector3 = %NavigationAgent3D.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * speed
	if %NavigationAgent3D.avoidance_enabled:
		%NavigationAgent3D.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector3):
	# don't move if attacking
	if target_in_range:
		return
	
	#if position == last_position:
		#print_debug("trying to unstuck")
		## force unstuck
		#position += safe_velocity
	#last_position = position
	
	velocity = safe_velocity
	if velocity.length_squared() > 10.0:
		look_at(global_position + velocity)
	move_and_slide()


func take_damage(amount: float) -> void:
	if is_dead:
		return
	
	health -= amount
	
	if health <= 0:
		is_dead = true
		die()
		return
	
	# change aggro
	if current_target == target:
		var closest_target: Node3D
		for t in towers_in_range:
			if closest_target == null:
				closest_target = t
				continue
			if global_position.distance_squared_to(t.global_position) < global_position.distance_squared_to(closest_target.global_position):
				closest_target = t
		if closest_target:
			current_target = closest_target

func die() -> void:
	#TODO: animation
	Events.enemy_died.emit()
	queue_free()


func _on_tower_detector_body_entered(body: Node3D) -> void:
	if body is Spawn or (body is Tower and body.can_be_damaged):
		towers_in_range.append(body)
		if current_target == target:
			print_debug("found tower, should switch target now")
			current_target = body
			target_in_range = false
			%NavigationAgent3D.set_target_position(current_target.global_position)


func _on_attack_windup_timer_timeout() -> void:
	# check target
	if not is_instance_valid(current_target):
		return
	
	%snd_attack.play()
	
	current_target.take_damage(damage)
	%AttackCooldownTimer.start(attack_cooldown)


func _on_attack_cooldown_timer_timeout() -> void:
	attack_current_target()

func attack_current_target() -> void:
	if not current_target:
		return
	
	look_at(current_target.global_position)
	
	#TODO: play windup sound?
	
	if %AnimationPlayer.has_animation(&"attack"):
		%AnimationPlayer.play(&"attack")
	else:
		push_warning(name, " is missing attack animation")
	
	%AttackWindupTimer.start(attack_windup)


func _on_attack_range_detector_body_entered(body: Node3D) -> void:
	if body == current_target:
		target_in_range = true
		attack_current_target()
