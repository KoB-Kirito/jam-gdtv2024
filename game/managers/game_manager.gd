extends Node


var current_round: int = 0

var current_enemy_count: int = 0

var coral_health: int = 10


func _ready() -> void:
	Events.enemy_spawned.connect(func(): current_enemy_count += 1)
	Events.enemy_died.connect(on_enemy_died)
	
	await get_tree().process_frame # wait one frame for ui to connect signals
	
	# start game
	start_build_phase()
	Events.coral_health_changed.emit(10)


func on_enemy_died() -> void:
	current_enemy_count -= 1
	if current_enemy_count == 0 and %BuildTimer.is_stopped():
		start_build_phase()


func start_build_phase() -> void:
	%RoundTimer.stop()
	%BuildTimer.start()
	Events.build_phase_started.emit(%BuildTimer.time_left)
	print_debug("Build phase started")


func start_next_round() -> void:
	current_round += 1
	Events.round_started.emit(current_round)
	%RoundTimer.start()
	print_debug("Round ", current_round, " started")


func _on_death_zone_body_entered(body: Node3D) -> void:
	print_debug("Enemy reached coral")
	Events.enemy_died.emit()
	body.queue_free()
	
	coral_health -= 1
	if coral_health <= 0:
		coral_health = 0
		#TODO
		print_debug("GAME OVER")
		Events.game_over.emit()
	Events.coral_health_changed.emit(coral_health)


func _on_round_timer_timeout() -> void:
	# if the round takes too long, force start next round
	start_build_phase()


func _on_build_timer_timeout() -> void:
	start_next_round()
