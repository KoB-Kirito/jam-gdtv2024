extends Node


var current_round: int = 0


func _ready() -> void:
	await get_tree().process_frame
	start_build_phase()


func _on_round_timer_timeout() -> void:
	start_build_phase()


func _on_build_timer_timeout() -> void:
	start_next_round()


func start_build_phase() -> void:
	%BuildTimer.start()
	Events.build_phase_started.emit(%BuildTimer.time_left)
	print_debug("Build phase started")


func start_next_round() -> void:
	current_round += 1
	Events.round_started.emit(current_round)
	%RoundTimer.start()
	print_debug("Round ", current_round, " started")
