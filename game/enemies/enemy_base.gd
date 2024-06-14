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

var main_target: Node3D
var current_target: Node3D
var targets_in_sight: Array[Node3D]
var targets_in_attack_range: Array[Node3D]

var is_dead: bool = false

var last_position: Vector3


func _ready() -> void:
	assert(main_target, "main_target is not set")
	current_target = main_target
	
	Events.enemy_spawned.emit()
	%NavigationAgent3D.set_target_position(current_target.global_position)
	%NavigationAgent3D.velocity_computed.connect(Callable(_on_velocity_computed))


func _physics_process(delta: float) -> void:
	if is_dead:
		velocity = Vector3.ZERO
		return
	
	if global_position.y < 0:
		global_position.y = 0
	
	# check main_target
	if not is_instance_valid(current_target):
		change_aggro()
	
	# don't move if attacking
	if current_target in targets_in_attack_range:
		if %AttackWindupTimer.is_stopped() and %AttackCooldownTimer.is_stopped():
			attack_current_target()
		return
	
	if %NavigationAgent3D.is_navigation_finished():
		return
	
	# move to main_target
	var next_path_position: Vector3 = %NavigationAgent3D.get_next_path_position()
	var new_velocity: Vector3 = global_position.direction_to(next_path_position) * speed
	if %NavigationAgent3D.avoidance_enabled:
		%NavigationAgent3D.set_velocity(new_velocity)
	else:
		_on_velocity_computed(new_velocity)


func _on_velocity_computed(safe_velocity: Vector3):
	# don't move if attacking
	if current_target in targets_in_attack_range:
		return
	
	velocity = safe_velocity
	if is_zero_approx(velocity.y) and velocity.length_squared() > 10.0:
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
	change_aggro()


func change_aggro() -> void:
	var distance_to_closest_target: float
	
	# try to get clostest target in attack range
	if targets_in_attack_range:
		var closest_target: Node3D = null
		var to_remove: Array[int] = []
		for i in targets_in_attack_range.size():
			var target = targets_in_attack_range[i]
			if not is_instance_valid(target):
				to_remove.append(i)
				continue
			
			# skip coral if possible
			if target == main_target:
				continue
			
			if not closest_target:
				closest_target = target
				distance_to_closest_target = global_position.distance_squared_to(closest_target.global_position)
				continue
			
			var distance = global_position.distance_squared_to(target.global_position)
			if distance < distance_to_closest_target:
				closest_target = target
				distance_to_closest_target = distance
			
		if closest_target:
			current_target = closest_target
			if %AttackWindupTimer.is_stopped() and %AttackCooldownTimer.is_stopped():
				attack_current_target()
			return
	
	# try to get closest target in sight
	if targets_in_sight:
		var closest_target: Node3D = null
		var to_remove: Array[int] = []
		for i in targets_in_sight.size():
			var target = targets_in_sight[i]
			if not is_instance_valid(target):
				to_remove.append(i)
				continue
			
			# skip coral if possible
			if target == main_target:
				continue
			
			if not closest_target:
				closest_target = target
				distance_to_closest_target = global_position.distance_squared_to(closest_target.global_position)
				continue
			
			var distance = global_position.distance_squared_to(target.global_position)
			if distance < distance_to_closest_target:
				closest_target = target
				distance_to_closest_target = distance
			
		if closest_target:
			current_target = closest_target
			%NavigationAgent3D.set_target_position(current_target.global_position)
			return
	
	current_target = main_target
	if current_target in targets_in_attack_range:
		if %AttackWindupTimer.is_stopped() and %AttackCooldownTimer.is_stopped():
			attack_current_target()
		
	else:
		%NavigationAgent3D.set_target_position(current_target.global_position)


func die() -> void:
	#TODO: animation
	Events.enemy_died.emit()
	queue_free()


func _on_tower_detector_body_entered(body: Node3D) -> void:
	if body is Spawn or (body is Tower and body.can_be_damaged):
		targets_in_sight.append(body)
		change_aggro()

func _on_tower_detector_body_exited(body: Node3D) -> void:
	if body is Spawn or (body is Tower and body.can_be_damaged):
		targets_in_sight.erase(body)


func _on_attack_windup_timer_timeout() -> void:
	# check main_target
	if not is_instance_valid(current_target):
		return
	
	%snd_attack.play()
	
	current_target.take_damage(damage)
	%AttackCooldownTimer.start(attack_cooldown)


func _on_attack_cooldown_timer_timeout() -> void:
	attack_current_target()

func attack_current_target() -> void:
	if not is_instance_valid(current_target):
		return
	
	if not current_target in targets_in_attack_range:
		return
	
	look_at(current_target.global_position)
	
	#TODO: play windup sound?
	
	if %AnimationPlayer.has_animation(&"attack"):
		%AnimationPlayer.play(&"attack")
	else:
		push_warning(name, " is missing attack animation")
	
	%AttackWindupTimer.start(attack_windup)


func _on_attack_range_detector_body_entered(body: Node3D) -> void:
	if not ((body is Tower and body.can_be_damaged) or body is Spawn):
		return
	
	targets_in_attack_range.append(body)
	
	if current_target == main_target:
		current_target = body
	
	if body == current_target:
		attack_current_target()


func _on_attack_range_detector_body_exited(body: Node3D) -> void:
	if not ((body is Tower and body.can_be_damaged) or body is Spawn):
		return
	
	targets_in_attack_range.erase(body)
