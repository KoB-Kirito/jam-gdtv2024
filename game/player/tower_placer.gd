extends Node3D


@onready var model: MeshInstance3D = %MeshInstance3D


func preview_green() -> void:
	RenderingServer.global_shader_parameter_set("preview_color", Color("00cc00a2"))

func preview_red() -> void:
	RenderingServer.global_shader_parameter_set("preview_color", Color("cc0000a2"))


func set_mesh(mesh: Mesh) -> void:
	model.mesh = mesh


func placement_check() -> bool:
	preview_red()
	
	if %Area3D.has_overlapping_bodies():
		print("overlapping bodies")
		return false
	
	#TODO: Check slopes via raycast
	
	preview_green()
	return true
