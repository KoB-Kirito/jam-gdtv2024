extends Node
## Global data


const GREEN = Color("00cc00a2")
const RED = Color("cc0000a2")

var current_level: int = 0

var resource: int = 0:
	set(value):
		resource = value
		Events.resource_changed.emit(resource)
