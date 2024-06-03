extends Tower




var heal_rate: float = 10.0 # Heilungsrate pro Sekunde
var heal_range: float = 100.0 # Reichweite der Heilung
var healing_beam_material: Material # Material für den Heilungsstrahl

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	# Finden und heilen von Türmen in Reichweite
	var defense = get_towers_in_range()
	for tower in defense:
		tower.heal(heal_rate * delta)

	# Zeige den Heilungsstrahl für die visuelle Rückmeldung
	update_healing_beam()

func get_towers_in_range() -> Array:
	var defense = []
	for node in get_tree().get_nodes_in_group("tower_group"):
		if node != self and global_transform.origin.distance_to(node.global_transform.origin) <= heal_range:
			defense.append(node)
	return defense

func update_healing_beam() -> void:
	# Füge hier den Code hinzu, um den visuellen Heilungsstrahl zu aktualisieren
	pass
