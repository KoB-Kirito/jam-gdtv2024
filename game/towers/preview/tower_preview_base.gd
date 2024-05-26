@tool
extends Node3D
class_name TowerPreview


var area_3d: Area3D
var hub_detector: Area3D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_3d = get_node("Area3D")
	hub_detector = get_node("HubDetector")


func check_placement() -> bool:
	# check if area is blocked
	if area_3d.has_overlapping_bodies():
		return false
	
	#TODO: Check if floor is planar via raycast
	
	# check if a hub is nearby
	if hub_detector.has_overlapping_bodies():
		if self is CoralHubPreview:
			return false
		else:
			return true
		
	else:
		if self is CoralHubPreview:
			return true
		else:
			return false


#region Editor-Only
func _get_configuration_warnings() -> PackedStringArray:
	if get_node_or_null("Area3D") == null:
		return ["Preview needs an Area3D that defines the collision area to check"]
	if get_node_or_null("HubDetector") == null:
		return ["Preview needs an Area3D that defines the collision area to check"]
	return []

func _notification(what: int) -> void:
	if not Engine.is_editor_hint():
		return
	match what:
		NOTIFICATION_EDITOR_PRE_SAVE, NOTIFICATION_CHILD_ORDER_CHANGED:
			update_configuration_warnings()
#endregion
