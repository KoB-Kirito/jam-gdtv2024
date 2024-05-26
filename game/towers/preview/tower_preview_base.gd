@tool
extends Node3D
class_name TowerPreview


@onready var area_3d: Area3D = $Area3D


func check_placement() -> bool:
	# check if area is blocked
	if area_3d.has_overlapping_bodies():
		return false
	
	#TODO: Check if floor is  via raycast
	
	return true


#region Editor-Only
func _get_configuration_warnings() -> PackedStringArray:
	#TODO: check if node is unique
	if get_node("Area3D") == null:
		return ["Preview needs an Area3D that defines the collision area to check"]
	return []

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE, NOTIFICATION_CHILD_ORDER_CHANGED:
			update_configuration_warnings()
#endregion

