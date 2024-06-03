extends Control


@export_file("*.tscn") var first_level: String


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file(first_level)


func _on_options_button_pressed() -> void:
	return #TODO: Fix
	%PauseMenu.show()


func _on_credits_button_pressed() -> void:
	pass #TODO


func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
	#TODO: Web
