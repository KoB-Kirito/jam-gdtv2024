extends Label


func _ready() -> void:
	hide()
	Events.game_over.connect(on_game_over)


func on_game_over() -> void:
	show()
