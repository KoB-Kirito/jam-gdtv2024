extends TextureButton
class_name TowerTile


var tower_data: TowerData


func _ready() -> void:
	if tower_data == null:
		return
	
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_SCALE
	
	texture_normal = tower_data.normal
	texture_hover = tower_data.hover
	texture_pressed = tower_data.active
	texture_disabled = tower_data.disabled
	tooltip_text = tower_data.name + "\n" + tower_data.description
	#TODO: Custom tooltip panel
	
	%CostLabel.text = str(tower_data.cost)
	
	Events.resource_changed.connect(on_resource_changed)


func on_resource_changed(new_value: int) -> void:
	# disable button if not enough resources
	if new_value < tower_data.cost:
		modulate = Color.DIM_GRAY
		disabled = true
		%CostLabel.modulate = Globals.RED
		
	else:
		modulate = Color.WHITE
		disabled = false
		%CostLabel.modulate = Color.WHITE
