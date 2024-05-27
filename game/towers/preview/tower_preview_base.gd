extends Node3D
class_name TowerPreview


var hubs_in_range: Array[CoralHub]


func _ready() -> void:
	%HubDetector.body_entered.connect(on_hub_detector_body_entered)
	%HubDetector.body_exited.connect(on_hub_detector_body_exited)


func on_hub_detector_body_entered(body: Node3D) -> void:
	print("body entered hub detector: ", body)
	
	if body is CoralHub:
		hubs_in_range.append(body)


func on_hub_detector_body_exited(body: Node3D) -> void:
	if body is CoralHub:
		hubs_in_range.erase(body)


func check_placement() -> bool:
	# check if area is blocked
	if %BlockedDetector.has_overlapping_bodies():
		return false
	
	#TODO: Check if floor is planar via raycast
	
	# don't allow hubs nearby other hubs
	if self is CoralHubPreview:
		return hubs_in_range.size() == 0
	
	# allow towers only near hubs that have connections left
	for hub in hubs_in_range:
		if hub.free_connections > 0:
			return true
	return false


func get_nearest_available_hub() -> CoralHub:
	for hub in hubs_in_range:
		if hub.free_connections > 0:
			return hub
	
	return null
