class_name Dancer
extends KinematicBody2D


var _velocity := Vector2.ZERO
var _name := String()
var _team := String()
var _opponent := String()
var _color := Color()
var _health_current := 0
var _health_max := 0
var _deftness_current := 0
var _deftness_max := 0
var _swiftness_current := 0
var _swiftness_max := 0
var _cockiness_current := 0
var _cockiness_max := 0
var _pas_draw := 0
var _exam_draw := 0

var _agent: NavigationAgent2D
var _timer_waitng
var _timer_moving
var _timer_parking
var _timer_examing
var _sprite
var _target

var _beacon



func _ready():
	_timer_waitng.connect("timeout", self, "_start_moving")
	_timer_moving.connect("timeout", self, "_update_pathfinding")
	_timer_parking.connect("timeout", self, "_examing")
	_timer_examing.connect("timeout", self, "_waiting")
	_agent.connect("velocity_computed", self, "move")


func _init(data_):
	_set_vars(data_)
	_set_sprites()


func _physics_process(delta: float) -> void:
	#if _team == "Champions":
	#	print(_timer_parking.is_stopped(),_timer_moving.is_stopped(),_timer_parking.get_time_left())
	if _timer_moving.is_stopped():
		return
	if _agent.is_navigation_finished():
		if _team == "Mobs":
			print(_target,_timer_moving.is_stopped())
		_parking()
	
	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)


func move(velocity: Vector2) -> void:
	_velocity = move_and_slide(velocity)
	_sprite.rotation = lerp_angle(_sprite.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())
	
	if _team == "Mobs":
		for i in get_slide_count():
			var collision = get_slide_collision(i)
			#print("Collided with: ", collision.collider.class_name)
			_set_target("last beacon")
			_parking()
			
#		if get_last_slide_collision() != null:
#			_get_nearest_beacon()
#			_parking()

func _update_pathfinding() -> void:
	_agent.set_target_location(_target.global_position)


func _set_target(type_: String = "classic") -> void:
	pass


func _start_moving() -> void:
	if _team == "Champions":
		print("_start_moving")
	_timer_waitng.stop()
	_timer_moving.start()
	_set_target("classic")
	_update_pathfinding()


func _parking() -> void:
	if _team == "Champions":
		print("_parking")
	_timer_moving.stop()
	_timer_parking.start()
	var tween := create_tween()
	tween.tween_property(self, "global_position", _target.global_position, _timer_parking.get_wait_time())


func _examing() -> void:
	_timer_parking.stop()
	_timer_examing.start()
	if _team == "Champions":
		print("_examing")


func _waiting() -> void:
	_timer_examing.stop()
	_timer_waitng.start()
	if _team == "Champions":
		print("_waiting")


func _get_nearest_beacon() -> void:
	var datas = []

func _set_vars(data_: Dictionary) -> void:
	_name = data_.name
	_team = data_.team 
	_opponent = Global.dict.opponent[_team]
	_health_max = data_.health 
	_health_current = _health_max
	_deftness_max = data_.deftness 
	_deftness_current = _deftness_max
	_swiftness_max = data_.swiftness 
	_swiftness_current = _swiftness_max
	_cockiness_max = data_.cockiness 
	_cockiness_current = _cockiness_max
	_pas_draw = data_.pas_draw
	_exam_draw = data_.exam_draw
	add_to_group(_team)


func _set_sprites() -> void:
	rotation_degrees = 45
	_sprite = Sprite.new()
	var path = "res://assets/dancer/"
	var name_ = _team+"_arrow.png"
	_sprite.texture = load(path+name_)
	_sprite.modulate = _color
	add_child(_sprite)
	
	_timer_moving = Timer.new()
	_timer_moving.wait_time = 0.1
	_timer_moving.autostart = false
	add_child(_timer_moving)
	
	_timer_waitng = Timer.new()
	_timer_waitng.wait_time = 1
	_timer_waitng.autostart = true
	_timer_waitng.one_shot = true
	add_child(_timer_waitng)
	
	_timer_parking = Timer.new()
	_timer_parking.wait_time = 0.5
	_timer_parking.autostart = false
	_timer_parking.one_shot = true
	add_child(_timer_parking)
	
	_timer_examing = Timer.new()
	_timer_examing.wait_time = 2
	_timer_examing.autostart = false
	_timer_examing.one_shot = true
	add_child(_timer_examing)
	
	_agent = NavigationAgent2D.new()
	_agent.path_desired_distance = 10
	_agent.target_desired_distance = 24
	_agent.path_max_distance = 10
	_agent.navigation_layers = 1
	_agent.avoidance_enabled = true
	_agent.radius = 0
	_agent.neighbor_dist = 200
	_agent.max_neighbors = 10
	_agent.time_horizon = 20
	_agent.max_speed = 40 * _deftness_current
	add_child(_agent)
	
	var _collision_shape = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.set_radius(16)
	_collision_shape.set_shape(shape)
	set_collision_layer_bit(1, false) 
	set_collision_layer_bit(2, true)
	set_collision_mask_bit(1, false) 
	set_collision_mask_bit(2, true)
	add_child(_collision_shape)
