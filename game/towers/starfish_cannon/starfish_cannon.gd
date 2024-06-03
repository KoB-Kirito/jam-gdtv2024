extends Tower



@export_range(0.1, 10.0, 0.1) var fire_rate: float = 2
@export_range(1.0, 30.0, 1.0) var damage: float = 2.0
@export var bullet_scene: PackedScene 
@export var burst_count: int = 3 #salve
@export var burst_interval: float = 0.1 #salve

var enemies_in_range: Array[Node3D] = []
var current_enemy: Enemy
var shooting_timer: Timer
var burst_timer: Timer #salve
var shots_fired_in_burst: int = 0 #salve

@onready var animation_player: AnimationPlayer = $Seesternkanone/AnimationPlayer


func _ready() -> void:
	#%PatrolZone2.body_entered.connect(_on_patrol_zone_body_entered) # is already connected via editor
	#%PatrolZone2.body_exited.connect(_on_patrol_zone_body_exited) # "
	
	shooting_timer = Timer.new()
	shooting_timer.wait_time = fire_rate # Beispiel-Feuerrate, 1 Schuss pro Sekunde
	shooting_timer.timeout.connect(_start_burst) #salve
	add_child(shooting_timer)
	shooting_timer.start()
	
	burst_timer = Timer.new() #salve
	burst_timer.wait_time = burst_interval #salve
	burst_timer.timeout.connect(_shoot) #salve
	add_child(burst_timer) #salve
	
	animation_player.play(&"Seekanone_idle")


func _process(_delta: float) -> void:
	pass
	#if current_enemy:
		#look_at_2d(current_enemy.global_position)


func _on_patrol_zone_body_entered(body: Node3D) -> void:
	if body is Enemy:
		#print_debug(body, "entered")
		if current_enemy == null:
			current_enemy = body
		enemies_in_range.append(body)
		#print(enemies_in_range.size())
		#print(body.global_position)
		#look_at_2d(body.global_position)


func _on_patrol_zone_body_exited(body: Node3D) -> void:
	if body is Enemy:
		#print(body, "exited")
		enemies_in_range.erase(body)
		if current_enemy == body:
			if enemies_in_range.size() > 0:
				current_enemy = enemies_in_range[0]
			else:
				current_enemy = null
		#print(enemies_in_range.size())


#func look_at_2d(target_position: Vector3) -> void:
	#var current_position = global_transform.origin
	#var direction = (target_position - current_position).normalized()
	#direction.y = 0  # Y-Achse ignorieren
	#look_at(current_position + direction, Vector3.UP)

func _start_burst() -> void: #salve
	if current_enemy:
		shots_fired_in_burst = 0
		burst_timer.start()
		animation_player.play(&"Seesternkanone_werfen")
		animation_player.animation_finished.connect(func(): animation_player.play(&"Seekanone_idle"), CONNECT_ONE_SHOT)

func _shoot() -> void:
	if current_enemy and shots_fired_in_burst < burst_count: #salve
		var bullet: StarfishBullet = bullet_scene.instantiate()
		bullet.direction = (current_enemy.global_position - global_transform.origin).normalized()
		bullet.damage = damage
		
		#print("Schieße Bullit in Richtung:", direction)
		get_parent().add_child(bullet)
		bullet.global_position = global_transform.origin #salve
		shots_fired_in_burst += 1 #salve
		if shots_fired_in_burst >= burst_count: #salve
			burst_timer.stop() #salve


#salve
#extends Tower
#
#
#@export_range(0.1, 10.0, 0.1) var fire_rate: float = 0.5
#@export_range(1.0, 30.0, 1.0) var damage: float = 2.0
#@export var bullet_scene: PackedScene
#
#var enemies_in_range: Array[Node3D] = []
#var current_enemy: Enemy
#var shooting_timer: Timer
#
#
#func _ready() -> void:
	##%PatrolZone2.body_entered.connect(_on_patrol_zone_body_entered) # is already connected via editor
	##%PatrolZone2.body_exited.connect(_on_patrol_zone_body_exited) # "
	#
	#shooting_timer = Timer.new()
	#shooting_timer.wait_time = fire_rate # Beispiel-Feuerrate, 1 Schuss pro Sekunde
	#shooting_timer.timeout.connect(_shoot)
	#add_child(shooting_timer)
	#shooting_timer.start()
#
#
#func _process(delta: float) -> void:
	#if current_enemy:
		#look_at_2d(current_enemy.global_position)
#
#
#func _on_patrol_zone_body_entered(body: Node3D) -> void:
	#if body is Enemy:
		##print_debug(body, "entered")
		#if current_enemy == null:
			#current_enemy = body
		#enemies_in_range.append(body)
		##print(enemies_in_range.size())
		##print(body.global_position)
		#look_at_2d(body.global_position)
#
#
#func _on_patrol_zone_body_exited(body: Node3D) -> void:
	#if body is Enemy:
		##print(body, "exited")
		#enemies_in_range.erase(body)
		#if current_enemy == body:
			#if enemies_in_range.size() > 0:
				#current_enemy = enemies_in_range[0]
			#else:
				#current_enemy = null
		##print(enemies_in_range.size())
#
#
#func look_at_2d(target_position: Vector3) -> void:
	#var current_position = global_transform.origin
	#var direction = (target_position - current_position).normalized()
	#direction.y = 0  # Y-Achse ignorieren
	#look_at(current_position + direction, Vector3.UP)
#
#
#func _shoot() -> void:
	#if current_enemy:
		#var bullet: StarfishBullet = bullet_scene.instantiate()
		#
		#bullet.direction = (current_enemy.global_position - global_transform.origin).normalized()
		#bullet.damage = damage
		#
		##print("Schieße Bullit in Richtung:", direction)
		#get_parent().add_child(bullet)
		#bullet.global_position = %Muzzle.global_position
