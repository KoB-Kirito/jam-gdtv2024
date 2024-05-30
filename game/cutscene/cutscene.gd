@tool
@icon("res://game/cutscene/Animation.svg")
extends Node3D
class_name Cutscene
## Cutscene base class.
## Allows cutscenes to be exported in the game manager.


signal finished

#BUG, HACK: Using Editor Description caused the scene icon to duplicate..
## Have no effect. Just for notes to organize cutscenes better.
@export_multiline var notes: String

## Cutscene will be played when that level ends.
## If multiple have the same level, they will be played in array order in succesion.
@export var level: int
@export var dialogs: Array[DialogData]


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	$AnimationPlayer.animation_finished.connect(on_animation_finished)


func on_animation_finished(anim_name: StringName) -> void:
	Events.cutscene_ended.emit()
	finished.emit()


func play_cutscene() -> void:
	Events.cutscene_started.emit()
	
	# the animation "cutscene" must be present!
	$AnimationPlayer.play(&"cutscene")


## Displays the dialog with the given index
func show_dialog(index: int, pause: bool) -> void:
	print_debug("showind dialog ", index, ", pause: ", pause)
	%DialogLayer.play(dialogs[index], pause)

func close_dialog() -> void:
	%DialogLayer.close()


func _get_configuration_warnings() -> PackedStringArray:
	if get_node_or_null("AnimationPlayer") == null:
		return ["This cutscene needs an AnimationPlayer as child"]
	if not $AnimationPlayer.has_animation(&"cutscene"):
		return ["AnimationPlayer has no animation named \"cutscene\""]
	return []

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE:
			update_configuration_warnings()
