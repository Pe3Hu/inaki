class_name Dancer
extends KinematicBody2D


const _missile := preload("res://assets/weapons/Missile.tscn")

var _velocity := Vector2.ZERO
var _name := String()
var _team := String()
var _opponent := String()
var _color := Color()
var _health_current := 0
var _health_max := 0
var _resource_current := 0
var _resource_max := 0
var _deftness_current := 0
var _deftness_max := 0
var _swiftness_current := 0
var _swiftness_max := 0
var _cockiness_current := 0
var _cockiness_max := 0
var _pas_draw := 0
var _exam_draw := 0
var _print_timer := true

onready var _travel_speed_slider := 100
onready var _drag_factor_slider := 0.1

onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var _timer_waitng: Timer = $TimerWating
onready var _timer_moving: Timer = $TimerMoving
onready var _timer_parking: Timer = $TimeParking
onready var _timer_examing: Timer = $TimerExaming
onready var _sprite := $Sprite
onready var _shoot_position := $ShootPosition

var _target_move
var _target_exam
var _beacons := []
var _ballroom

func _ready():
	_timer_waitng.connect("timeout", self, "start_moving")
	_timer_moving.connect("timeout", self, "update_pathfinding")
	_timer_parking.connect("timeout", self, "start_examing")
	_timer_examing.connect("timeout", self, "end_examing")
	_agent.connect("velocity_computed", self, "move")
	
	_agent.max_speed = 80 * _deftness_current
	#set_collision_layer_bit(2, true)
	#"Mobs":
	#	_agent.radius = 40
	set_sprite()


func _physics_process(delta: float) -> void:
	if _timer_moving.is_stopped():
		return
	match _team:
		"Mobs":
			if _ballroom._d/2 > _agent.distance_to_target():
				set_target_move("last beacon")
				start_parking()
		"Champions":
			if _agent.is_navigation_finished():
				start_parking()
	
	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)


func move(velocity: Vector2) -> void:
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
	_velocity = move_and_slide(velocity)
	_sprite.rotation = lerp_angle(_sprite.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())
	

func update_pathfinding() -> void:
	_agent.set_target_location(_target_move.global_position)


func set_target_move(type_: String = "classic") -> void:
	pass


func start_moving() -> void:
	if _team == "Champions" && _print_timer:
		print("_start_moving")
	_timer_waitng.stop()
	_timer_moving.start()
	set_target_move("classic")
	update_pathfinding()


func start_parking() -> void:
	if _team == "Champions" && _print_timer:
		print("_parking")
	_timer_moving.stop()
	_timer_parking.start()
	var tween := create_tween()
	tween.tween_property(self, "global_position", _target_move.global_position, _timer_parking.get_wait_time())


func start_examing() -> void:
	_timer_parking.stop()
	_timer_examing.start()
	if _team == "Champions" && _print_timer:
		print("_examing")


func end_examing() -> void:
	shoot()
	start_waiting()


func start_waiting() -> void:
	_timer_examing.stop()
	_timer_waitng.start()
	if _team == "Champions" && _print_timer:
		print("_waiting")


func shoot() -> void:
	var missile := _missile.instance() as Missile
	
	#missile.drag_factor = _drag_factor_slider
	#missile.max_speed = _travel_speed_slider
	
	missile._target = _target_exam
	missile.global_position = _shoot_position.global_position
	missile.rotation = rotation
	
	add_child(missile)


func update_target_exam() -> void:
	var b = is_inside_tree()
	var a = get_tree()
	var opponents = get_tree().get_nodes_in_group(_opponent)
	_target_exam = opponents.front()


func set_vars(data_: Dictionary) -> void:
	_ballroom = data_.ballroom
	_name = data_.name
	_team = data_.team 
	_opponent = Global.dict.opponent[_team]
	_health_max = data_.health 
	_health_current = _health_max
	if data_.keys().has("resource"):
		_resource_max = data_.resource 
		_resource_current = _resource_max
	_deftness_max = data_.deftness 
	_deftness_current = _deftness_max
	_swiftness_max = data_.swiftness 
	_swiftness_current = _swiftness_max
	_cockiness_max = data_.cockiness 
	_cockiness_current = _cockiness_max
	_pas_draw = data_.pas_draw
	_exam_draw = data_.exam_draw
	add_to_group(_team)


func set_sprite() -> void:
	var path = "res://assets/dancer/"
	var name_ = _team+"_arrow.png"
	_sprite.texture = load(path+name_)
	_sprite.modulate = _color
