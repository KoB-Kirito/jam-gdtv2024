extends HBoxContainer


@export var tower_tile_scene: PackedScene
@export var towers: Array[TowerData]


func _ready() -> void:
	# remove debug buttons
	for child in get_children():
		child.queue_free()
	
	Events.build_phase_started.connect(on_build_started)
	
	on_build_started(0)


func on_build_started(level: int) -> void:
	for tower: TowerData in towers:
		if tower.level == level:
			var tile: TowerTile = tower_tile_scene.instantiate()
			tile.tower_data = tower
			
			tile.pressed.connect(on_tower_button_pressed.bind(tile))
			add_child(tile)


func on_tower_button_pressed(tile: TowerTile) -> void:
	Events.ui_tower_selected.emit(tile.tower_data)
