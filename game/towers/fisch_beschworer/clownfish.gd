extends StaticBody3D

class_name Spawneinheit

@export var interval: float = 2.0
@export var damage: float = 1.0
@export var deathtimer = 10

var enemies_in_range: Array[Node3D] = []
var current_enemy: Enemy
var shooting_timer: Timer


var max_health: float = 100
var current_health: float = 100
var move_speed: float = 5
var target_enemy: Node3D = null

func _ready() -> void:
	%DamageTimer.start(interval)
	%DeathTimer.start(deathtimer)


func _on_damage_timer_timeout() -> void:
	if not enemies_in_range:
		return
	
		# damage
	for enemy: Enemy in enemies_in_range:
		enemy.take_damage(damage)

func _process(delta: float) -> void:
	if target_enemy:
		var direction = (target_enemy.global_transform.origin - global_transform.origin).normalized()
		global_transform.origin += direction * move_speed * delta

func take_damage(damage: float) -> void:
	current_health -= damage
	if current_health <= 0:
		queue_free()

func _on_attack_zone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		print_debug(body, "entered")
		if current_enemy == null:
			current_enemy = body
		enemies_in_range.append(body)
		#print(enemies_in_range.size())
		#print(body.global_position)


func _on_attack_zone_body_exited(body: Node3D) -> void:
	if body is Enemy:
		print(body, "exited")
		enemies_in_range.erase(body)
		if current_enemy == body:
			if enemies_in_range.size() > 0:
				current_enemy = enemies_in_range[0]
			else:
				current_enemy = null

func attack_target() -> void:
	pass


func _on_death_timer_timeout() -> void:
	queue_free()
