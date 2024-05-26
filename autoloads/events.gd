extends Node
## Global event bus


signal game_over

signal round_started(number: int)
signal build_phase_started(duration: float)

signal enemy_spawned
signal enemy_died

signal coral_health_changed(new_health: int)

signal ui_tower_selected(tower: TowerData)
