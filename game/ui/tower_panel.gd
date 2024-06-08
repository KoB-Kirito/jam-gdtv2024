extends HBoxContainer


@export var tower_tile_scene: PackedScene
@export var towers: Array[TowerData]

var current_level: int = 0
var current_tiles: Array[TowerTile]


func _ready() -> void:
	# remove debug buttons
	for child in get_children():
		child.queue_free()
	
	Events.round_started.connect(func(level: int): current_level = level)
	Events.build_phase_started.connect(on_build_started)


func on_build_started(duration: float) -> void:
	add_towers(current_level)


func add_towers(level: int) -> void:
	#print_debug("checking towers for level", level)
	for tower: TowerData in towers:
		if tower.level == level:
			print_debug("Adding ", tower.name)
			var tile: TowerTile = tower_tile_scene.instantiate()
			tile.tower_data = tower
			
			tile.pressed.connect(on_tower_button_pressed.bind(tile.tower_data))
			add_child(tile)
			
			# hide reef root on the first level and show on second
			if tower.name == "Reef Root":
				current_tiles.push_front(tile)
				move_child(tile, 0)
				
			else:
				current_tiles.append(tile)



func on_tower_button_pressed(tower_data: TowerData) -> void:
	Events.ui_tower_selected.emit(tower_data)


func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		if current_tiles.size() >= 1 and not current_tiles[0].disabled:
			Events.ui_tower_selected.emit(current_tiles[0].tower_data)
			
	elif event.is_action_pressed("2"):
		if current_tiles.size() >= 2 and not current_tiles[1].disabled:
			Events.ui_tower_selected.emit(current_tiles[1].tower_data)
			
	elif event.is_action_pressed("3"):
		if current_tiles.size() >= 3 and not current_tiles[2].disabled:
			Events.ui_tower_selected.emit(current_tiles[2].tower_data)
			
	elif event.is_action_pressed("4"):
		if current_tiles.size() >= 4 and not current_tiles[3].disabled:
			Events.ui_tower_selected.emit(current_tiles[3].tower_data)
			
	elif event.is_action_pressed("5"):
		if current_tiles.size() >= 5 and not current_tiles[4].disabled:
			Events.ui_tower_selected.emit(current_tiles[4].tower_data)
			
	elif event.is_action_pressed("6"):
		if current_tiles.size() >= 6 and not current_tiles[5].disabled:
			Events.ui_tower_selected.emit(current_tiles[5].tower_data)
			
	elif event.is_action_pressed("7"):
		if current_tiles.size() >= 7 and not current_tiles[6].disabled:
			Events.ui_tower_selected.emit(current_tiles[6].tower_data)
			
	elif event.is_action_pressed("8"):
		if current_tiles.size() >= 8 and not current_tiles[7].disabled:
			Events.ui_tower_selected.emit(current_tiles[7].tower_data)
			
	elif event.is_action_pressed("9"):
		if current_tiles.size() >= 9 and not current_tiles[8].disabled:
			Events.ui_tower_selected.emit(current_tiles[8].tower_data)
