extends HBoxContainer


@export var tower_tile_scene: PackedScene
@export var towers: Array[TowerData]


func _ready() -> void:
	# remove debug buttons
	for child in get_children():
		child.queue_free()
	
	# create buttons from data
	for tower: TowerData in towers:
		var tile: TowerTile = tower_tile_scene.instantiate()
		tile.tower_data = tower
		
		tile.pressed.connect(on_tower_button_pressed.bind(tile))
		add_child(tile)


func on_tower_button_pressed(tile: TowerTile) -> void:
	Events.ui_tower_selected.emit(tile.tower_data)
