extends Tower



@export_range(0.1, 10.0, 0.1) var spawn_rate: float = 10
@export var spawn_scene: PackedScene

var enemies_in_range: Array[Node3D] = []
var current_enemy: Enemy
var shooting_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shooting_timer = Timer.new()
	shooting_timer.wait_time = spawn_rate # Beispiel-Spawnrate
	shooting_timer.timeout.connect(_on_timer_timeout)
	add_child(shooting_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_patrol_zone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		# Gegner hinzufügen
		if current_enemy == null:
			current_enemy = body
		enemies_in_range.append(body)
		if enemies_in_range.size() == 1: # Starten des Timers, wenn dies der erste Gegner ist
			shooting_timer.start()

func _on_patrol_zone_body_exited(body: Node3D) -> void:
	if body is Enemy:
		# Gegner entfernen
		enemies_in_range.erase(body)
		if current_enemy == body:
			if enemies_in_range.size() > 0:
				current_enemy = enemies_in_range[0]
			else:
				current_enemy = null
		if enemies_in_range.size() == 0: # Timer stoppen, wenn keine Gegner mehr da sind
			shooting_timer.stop()

func _on_timer_timeout() -> void:
	if enemies_in_range.size() > 0:
		_spawn()

func _spawn() -> void:
	if spawn_scene:
		var unit: Node3D = spawn_scene.instantiate()
		unit.global_transform.origin = self.global_transform.origin + Vector3(1, 0, 1) # Beispiel-Position
		get_parent().add_child(unit)

		if unit is Spawneinheit:
			var spawn_unit = unit as Spawneinheit
			spawn_unit.target_enemy = current_enemy # Setze das Ziel des Einheit auf den aktuellen Gegner
		else:
			print("Spawned unit is not of type SpawnUnit!")
	else:
		print("No spawn scene assigned!")
