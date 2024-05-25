extends Label


var current_round: int


func _ready() -> void:
	Events.round_started.connect(on_round_started)
	Events.build_phase_started.connect(on_build_phase_started)


func on_round_started(number: int) -> void:
	%NextRoundTimer.stop()
	current_round = number
	text = "Wave " + str(number)
	modulate = Color.RED


func on_build_phase_started(duration: float) -> void:
	%NextRoundTimer.start(duration)
	modulate = Color.GREEN


func _physics_process(delta: float) -> void:
	if %NextRoundTimer.is_stopped():
		return
	
	text = "Wave " + str(current_round + 1) + " starts in " + str(round(%NextRoundTimer.time_left)) + "..."
