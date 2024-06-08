extends Node
## Global event bus


signal game_over

signal round_started(number: int)
signal build_phase_started(duration: float)

signal enemy_spawned
signal enemy_died

signal coral_health_changed(new_health: int)

signal ui_tower_selected(tower: TowerData)

signal build_mode_entered
signal build_mode_exited

signal waste_collected(value: int)
signal resource_changed(new_value: int)

signal cutscene_started
signal cutscene_ended

signal tower_placed
signal hub_placed
