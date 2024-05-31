extends Node3D


func _ready() -> void:
	# select random nacho
	match randi_range(0, 2):
		1:
			$Nacho2.hide()
			$Nacho3.hide()
			
		2:
			$Nacho1.hide()
			$Nacho3.hide()
			
		3:
			$Nacho1.hide()
			$Nacho2.hide()
