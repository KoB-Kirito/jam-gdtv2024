extends CanvasLayer


class Options:
	var scene_path: String
	
	var transition: int = FADE
	var color: Color = Color.BLACK
	var duration: float = 1.0
	
	var new_bgm: AudioStream
	var volume: float = 0.0
	
	func _init(new_scene_path: String) -> void:
		scene_path = new_scene_path


const MARGIN = 10

enum {SLIDE, FADE}


func get_right_position() -> float:
	return get_viewport().get_visible_rect().size.x + MARGIN

func get_middle_position() -> float:
	return - %Fade.size.x * 0.2

func get_left_position() -> float:
	return - %Fade.size.x - MARGIN 


func _ready() -> void:
	%Fade.position.x = get_right_position()


func change_scene(data: Options) -> void:
	# set gradient color
	%Fade.texture.gradient.set_color(1, Color(data.color, 1.0))
	%Fade.texture.gradient.set_color(2, Color(data.color, 1.0))
	%Fade.show()
	
	var tween = create_tween()
	
	match data.transition:
		SLIDE:
			%Fade.modulate = Color.WHITE
			%Fade.position.x = get_right_position()
			
			if data.new_bgm:
				tween.tween_callback(func(): Bgm.fade_out(data.duration / 2))
			tween.tween_property(%Fade, "position:x", get_middle_position(), data.duration / 2)
			
			tween.tween_callback(func(): get_tree().change_scene_to_file(data.scene_path))
			
			if data.new_bgm:
				tween.tween_callback(func(): Bgm.fade_to(data.new_bgm, data.volume, data.duration / 2))
			tween.tween_property(%Fade, "position:x", get_left_position(), data.duration / 2)
		
		FADE:
			%Fade.modulate = Color.TRANSPARENT
			%Fade.position.x = get_middle_position()
			
			if data.new_bgm:
				tween.tween_callback(func(): Bgm.fade_out(data.duration / 2))
			tween.tween_property(%Fade, "modulate", Color.WHITE, data.duration / 2)
			
			tween.tween_callback(func(): get_tree().change_scene_to_file(data.scene_path))
			
			if data.new_bgm:
				tween.tween_callback(func(): Bgm.fade_to(data.new_bgm, data.volume, data.duration / 2))
			tween.tween_property(%Fade, "modulate", Color.TRANSPARENT, data.duration / 2)
	
	tween.tween_callback(func(): %Fade.hide())
