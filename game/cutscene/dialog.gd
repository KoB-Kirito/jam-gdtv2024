extends CanvasLayer


var text_tween: Tween


func _ready() -> void:
	hide()


## Will play the given dialog.
## If animation_player is provided, will pause until player input.
func play(dialog: DialogData, pause: bool) -> void:
	# apply data
	%Image.texture = dialog.image
	%Text.text = dialog.text
	
	if text_tween and text_tween.is_running():
		text_tween.stop()
	%Text.visible_ratio = 0.0
	text_tween = create_tween()
	text_tween.tween_property(%Text, "visible_ratio", 1.0, 0.1 + dialog.text.length() * 0.03)
	
	# pause game
	if pause:
		get_tree().paused = true
	
	# show dialog
	show()


func close() -> void:
	hide()
	get_tree().paused = false


func _on_dialog_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		print_debug("dialog catched mouse click")
		if get_tree().paused:
			close()
