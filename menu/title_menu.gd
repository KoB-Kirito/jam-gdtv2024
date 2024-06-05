extends Control


@export_file("*.tscn") var first_level: String


func _ready() -> void:
	PauseMenu.enabled = true
	%CreditsTextLabel.hide()
	%RulesTextLabel.hide()
	%Rules.hide()


func _on_play_button_pressed() -> void:
	var transition_options := SceneTransition.Options.new(first_level)
	transition_options.color = Color(0.21, 0.58, 0.95) #fog color
	transition_options.new_bgm = load("res://assets/sounds/MenuTheme.mp3")
	transition_options.volume = -20.0
	SceneTransition.change_scene(transition_options)
	
	#get_tree().change_scene_to_file(first_level)


#func _on_options_button_pressed() -> void:
#	PauseMenu.toggle()


func _on_credits_button_pressed() -> void:
	%Rules.show()
	%CreditsTextLabel.show()


func _on_rules_button_pressed() -> void:
	%Rules.show()
	%RulesTextLabel.show()


func _on_rules_gui_input(event: InputEvent) -> void:
	if event.is_pressed() and event is InputEventMouseButton:
		%RulesTextLabel.hide()
		%CreditsTextLabel.hide()
		%Rules.hide()


#func _on_quit_game_button_pressed() -> void:
#	get_tree().quit()
#	#TODO: Web
