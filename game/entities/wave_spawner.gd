extends Node3D


## Spawned enemies will walk to this target
@export var target: Node3D
@export var waves: Array[Wave]


func _ready() -> void:
	#TEST
	#%Visual.hide()
	Events.round_started.connect(on_round_started)


func on_round_started(number: int) -> void:
	for wave in waves:
		if wave.round == number:
			send_wave(wave)


func send_wave(wave: Wave) -> void:
	for i in wave.amount:
		var enemy := wave.enemy.instantiate() as Enemy
		add_child(enemy)
		enemy.global_position = global_position
		enemy.target = target
		await get_tree().create_timer(wave.seperation).timeout


func _get_configuration_warnings() -> PackedStringArray:
	if target == null:
		return ["No target set"]
	return []
