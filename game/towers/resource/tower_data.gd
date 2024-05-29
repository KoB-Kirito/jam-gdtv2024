extends Resource
class_name TowerData


@export var cost: int = 10
@export var name: String
@export_multiline var description: String

@export_group("Icons")
@export var normal: Texture2D
@export var hover: Texture2D
@export var active: Texture2D
@export var disabled: Texture2D

@export_group("")
@export var preview_scene: PackedScene
@export var scene: PackedScene
