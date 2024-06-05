extends CharacterBody3D
class_name Spawn


signal health_changed(new_health: float)
signal died

## Self-damage interval
@export var decay_interval: float = 2.0
## Self-damage per interval
@export var decay_rate: float = 2.0

@export var max_health: float = 40.0
@export var move_speed: float = 16.0
@export var wander_speed: float = 2.0
@export var wander_range: float = 8.0

@export_group("Attack")
@export var damage: float = 5.0
@export var attack_range: float = 1.5
## Time it takes for the animation to "hit"
@export var attack_windup: float = 1.5
## Time after attack until it attacks again
@export var attack_cooldown: float = 2.0

enum State {
	WANDER,
	HUNT,
	ATTACK,
}
var state: State

var current_target: Enemy
var spawn_position: Vector3
var wander_target: Vector3

@onready var current_health: float = max_health:
	set(value):
		current_health = value
		health_changed.emit(current_health)
		if current_health <= 0:
			#TODO: die animation
			died.emit()
			queue_free()


func _ready() -> void:
	state = State.WANDER
	%DecayTimer.start(decay_interval)


func _physics_process(delta: float) -> void:
	match state:
		State.WANDER:
			if global_position.distance_squared_to(wander_target) < 4.0:
				get_new_wander_target()
			var direction = global_position.direction_to(wander_target)
			velocity = direction * wander_speed
			
			if current_target:
				state = State.HUNT
		
		State.HUNT:
			if not current_target:
				state = State.WANDER
				return
			
			if global_position.distance_squared_to(current_target.global_position) < 2.0:
				push_warning("Too close to enemy")
				state = State.ATTACK
				attack_target()
				return
			
			var direction = global_position.direction_to(current_target.global_position)
			velocity = direction * move_speed
		
		State.ATTACK:
			if not current_target:
				state = State.WANDER
			return
	
	if velocity:
		look_at(global_position + velocity)
		move_and_slide()


func get_new_wander_target() -> void:
	wander_target = spawn_position + Vector3(randf_range(-wander_range, wander_range), 0, randf_range(-wander_range, wander_range))


func _on_decay_timer_timeout() -> void:
	current_health -= decay_rate


func take_damage(amount: float) -> void:
	current_health -= amount


func _on_attack_range_detector_body_entered(body: Node3D) -> void:
	if state == State.ATTACK:
		return
	
	if body == current_target:
		state = State.ATTACK
		attack_target()


func attack_target() -> void:
	if current_target:
		look_at(current_target.global_position)
		$AnimationPlayer.play("attack")
		%AttackWindupTimer.start(attack_windup)

func _on_attack_windup_timer_timeout() -> void:
	if not current_target:
		state = State.WANDER
		return
	
	current_target.take_damage(damage)
	#TODO: play sound
	%AttackCooldownTimer.start(attack_cooldown)

func _on_attack_cooldown_timer_timeout() -> void:
	attack_target()


func _on_attack_range_detector_body_exited(body: Node3D) -> void:
	if body == current_target and not is_queued_for_deletion():
		#print_debug("target left area")
		state = State.HUNT
		%AnimationPlayer.stop()
		%AttackWindupTimer.stop()
		%AttackCooldownTimer.stop()
