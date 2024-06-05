extends Control


@export_file("*.tscn") var next_scene: String

@export_group("Fade In")
@export var fade_in_duration: float = 1.0
@export var fade_in_transition: Tween.TransitionType
@export var fade_in_ease: Tween.EaseType

@export_group("Stay")
@export var stay_duration: float = 3.0

@export_group("Fade Out")
@export var fade_out_duration: float = 1.0
@export var fade_out_transition: Tween.TransitionType
@export var fade_out_ease: Tween.EaseType


func _ready() -> void:
	PauseMenu.enabled = false
	
	var tween := create_tween()
	
	# godot
	tween.tween_property(%Fade, "modulate", Color.TRANSPARENT, fade_in_duration).set_trans(fade_in_transition).set_ease(fade_in_ease)
	tween.tween_interval(stay_duration)
	tween.tween_property(%Fade, "modulate", Color.WHITE, fade_out_duration).set_trans(fade_out_transition).set_ease(fade_out_ease)
	
	#TODO: Team splash, Best played with controller?, ...
	
	var transition_options := SceneTransition.Options.new(next_scene)
	transition_options.duration = 0.5
	transition_options.color = Color(0.14, 0.14, 0.14)
	transition_options.new_bgm = load("res://assets/sounds/MenuTheme.mp3")
	transition_options.volume = -20.0
	
	tween.tween_callback(func(): SceneTransition.change_scene(transition_options))
