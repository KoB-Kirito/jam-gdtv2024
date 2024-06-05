extends Area3D
class_name SeahorseBullet

@onready var collision_shape_3d = %CollisionShape3D

var speed: float = 8.5
var direction: Vector3
var damage: float


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	
	var timeout_timer = Timer.new()
	timeout_timer.wait_time = 3  # Beispiel: Kugel wird nach 5 Sekunden entfernt
	timeout_timer.one_shot = true
	timeout_timer.timeout.connect(_on_timeout_timer_timeout)
	add_child(timeout_timer)
	timeout_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if direction:
		global_transform.origin += direction * speed * delta

func _on_body_entered(body: Node) -> void:
	#print_debug("Kollision mit:", body.name)
	if body is Enemy:
		body.take_damage(damage)
	
	#TODO: Impact effect? Sound?
	
	queue_free()

func _on_timeout_timer_timeout():
	queue_free()
