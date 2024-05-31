extends Tower
## SeaUrchin
## Damages enemies in an area in an interval


@export var damage: float = 1.0
@export var interval: float = 2.0

var enemies_in_range: Array[Enemy]


func _ready() -> void:
	%DamageTimer.start(interval)


func _on_damage_timer_timeout() -> void:
	if not enemies_in_range:
		return
	
	# animation
	var tween = create_tween()
	tween.tween_property(%Model, "scale", Vector3(3.0, 3.0, 3.0), 0.6).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(%Model, "scale", Vector3(1.0, 1.0, 1.0), 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	# damage
	for enemy: Enemy in enemies_in_range:
		enemy.take_damage(damage)


func _on_damage_area_body_entered(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.append(body)


func _on_damage_area_body_exited(body: Node3D) -> void:
	if body is Enemy:
		enemies_in_range.erase(body)
