extends Area3D
class_name StarfishBullet
#TODO: Add starfish model


var speed: float = 15.0
var direction: Vector3
var damage: float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)
	#print("Bullit bereit mit Geschwindigkeit:", speed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if direction:
		global_transform.origin += direction * speed * delta
		#print("Bullet bewegt sich in Richtung:", direction)


#func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	#if direction:
		#var velocity = direction * speed
		#state.transform.origin += velocity * state.step
		#print("Projektil bewegt sich in Richtung:", direction)


func _on_body_entered(body: Node) -> void:
	#print_debug("Kollision mit:", body.name)
	if body is Enemy:
		body.take_damage(damage)
	
	#TODO: Impact effect? Sound?
	
	queue_free()


func _on_timeout_timer_timeout() -> void:
	# if the bullet never hits something, we have to free it eventually
	queue_free()
