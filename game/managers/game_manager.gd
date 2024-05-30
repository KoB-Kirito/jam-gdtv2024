extends Node
## Central manager for game logic


## Main building life points
@export var coral_health: int = 100
@export var starting_resources: int = 10

## Will parse all cutscenes under that node
@export var cutscenes_parent: Node

var cutscenes: Array[Cutscene]

var current_round: int = 0
var current_enemy_count: int = 0


func _ready() -> void:
	# connect global signals
	Events.enemy_spawned.connect(func(): current_enemy_count += 1)
	Events.enemy_died.connect(on_enemy_died)
	
	Events.waste_collected.connect(on_waste_collected)
	
	# parse cutscenes
	for node in cutscenes_parent.get_children():
		if node is Cutscene:
			cutscenes.append(node)
	
	await get_tree().process_frame # wait one frame for ui to connect signals
	
	# init values
	Events.coral_health_changed.emit(coral_health)

	Globals.resource = starting_resources
	
	# start game cycle
	start_build_phase()


func on_enemy_died() -> void:
	current_enemy_count -= 1
	if current_enemy_count == 0 and %BuildTimer.is_stopped():
		start_build_phase()


func start_build_phase() -> void:
	%RoundTimer.stop()
	
	# play cutscenes
	print_debug("playing cutscenes for level ", current_round)
	for cutscene in cutscenes:
		if cutscene.level == current_round:
			cutscene.play_cutscene()
			await cutscene.finished
	
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
	#TODO: warn player


func _on_round_timer_timeout() -> void:
	# if the round takes too long, force start next round
	start_build_phase()


func _on_build_timer_timeout() -> void:
	start_next_round()


func _on_base_took_damage(amount: Variant) -> void:
	coral_health -= amount
	if coral_health <= 0:
		coral_health = 0
		#TODO
		print_debug("GAME OVER")
		Events.game_over.emit()
	Events.coral_health_changed.emit(coral_health)


func _on_warning_zone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		#TODO: Warn player
		print_debug("Enemy is near coral")
		pass


func on_waste_collected(value: int) -> void:
	Globals.resource += value
