extends Resource
class_name WaveData


## Spawns on that round
@export var round: int = 1
@export var enemy: PackedScene
@export var amount: int = 10
## Delay between spawns to avoid clumps
@export_range(0.1, 5.0, 0.1) var seperation: float = 1.0
