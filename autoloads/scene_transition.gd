extends CanvasLayer


const MARGIN = 10

enum {SLIDE, FADE}


func get_right_position() -> float:
	return get_viewport().size.x + MARGIN

func get_middle_position() -> float:
	return - %Fade.size.x * 0.2

func get_left_position() -> float:
	return - %Fade.size.x - MARGIN 


func _ready() -> void:
	%Fade.position.x = get_right_position()


func change_scene(scene_path: String, animation: int, duration: float, color: Color) -> void:
	# set gradient color
	%Fade.texture.gradient.set_color(1, Color(color, 1.0))
	%Fade.texture.gradient.set_color(2, Color(color, 1.0))
	
	var tween = create_tween()
	
	match animation:
		SLIDE:
			%Fade.modulate = Color.WHITE
			%Fade.position.x = get_viewport().size.x + MARGIN
			
			tween.tween_property(%Fade, "position:x", get_middle_position(), duration / 2)
			tween.tween_callback(func(): get_tree().change_scene_to_file(scene_path))
			tween.tween_property(%Fade, "position:x", get_left_position(), duration / 2)
		
		FADE:
			%Fade.modulate = Color.TRANSPARENT
			%Fade.position.x = get_middle_position()
			
			tween.tween_property(%Fade, "modulate", Color.WHITE, duration / 2)
			tween.tween_callback(func(): get_tree().change_scene_to_file(scene_path))
			tween.tween_property(%Fade, "modulate", Color.TRANSPARENT, duration / 2)
