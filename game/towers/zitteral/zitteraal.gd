extends Tower

@export var damage: float = 0.5
@export var interval: float = 0.1

var enemies_in_range: Array[Enemy]

# Reference to the GPUParticles3D node
var particles: GPUParticles3D


func _ready() -> void:
	%DamageTimer.start(interval)
	particles = get_node("GPUParticles3D")
	particles.hide()  # Ensure particles are hidden initially

func _on_damage_timer_timeout() -> void:
	if not enemies_in_range:
		particles.hide()  # Hide particles if no enemies are in range
		return
	
	particles.show()  # Show particles if enemies are in range
	
	# damage
	for enemy: Enemy in enemies_in_range:
		enemy.take_damage(damage)
		



func _on_patrolzone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)
		if len(enemies_in_range) == 1:  # Show particles when the first enemy enters the range
			particles.show()
		#print("entered")


func _on_patrolzone_body_exited(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.erase(body)
		if len(enemies_in_range) == 0:  # Hide particles when the last enemy exits the range
			particles.hide()
		#print("exited")
