extends HBoxContainer


@export var towers: Array[Tower]

var button_size: Vector2 = Vector2(80, 80)


func _ready() -> void:
	if get_child_count():
		button_size = get_child(0).custom_minimum_size
	
	for child in get_children():
		child.queue_free()
	
	for tower: Tower in towers:
		var button := TextureButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = TextureButton.STRETCH_SCALE
		button.custom_minimum_size = button_size
		button.texture_normal = tower.icon
		button.tooltip_text = tower.name + "\n" + tower.description
		button.pressed.connect(on_tower_button_pressed.bind(tower))
		add_child(button)
		button.duplicate(0)


func on_tower_button_pressed(tower: Tower) -> void:
	print(tower.name)
