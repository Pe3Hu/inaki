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
var _timer
var _sprite
var _target


func _ready():
	_timer.connect("timeout", self, "_update_pathfinding")
	_agent.connect("velocity_computed", self, "move")


func _init(data_):
	_set_vars(data_)
	_set_sprites()


func _physics_process(delta: float) -> void:
	if _agent.is_navigation_finished():
		_find_target_path()
		print(_target)
		return

	var target_global_position := _agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * _agent.max_speed
	var steering := (desired_velocity - _velocity) * delta * 4.0
	_velocity += steering
	_agent.set_velocity(_velocity)


func move(velocity: Vector2) -> void:
	_velocity = move_and_slide(velocity)
	_sprite.rotation = lerp_angle(_sprite.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())


func _update_pathfinding() -> void:
	_agent.set_target_location(_target.global_position)


func _find_target_path() -> void:
	var opponents = get_tree().get_nodes_in_group(_opponent)
	_target = get_node(opponents.front())


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
	_sprite = Sprite.new()
	add_child(_sprite)
	var path = "res://assets/dancer/"
	var name_ = _team+"_arrow.png"
	_sprite.texture = load(path+name_)
	_sprite.modulate = _color
	_timer = Timer.new()
	_timer.wait_time = 0.1
	_timer.autostart = true
	add_child(_timer)
	_agent = NavigationAgent2D.new()
	_agent.path_desired_distance = 20
	_agent.target_desired_distance = 20
	_agent.path_max_distance = 20
	_agent.navigation_layers = 1
	_agent.avoidance_enabled = true
	_agent.radius = 60
	_agent.neighbor_dist = 200
	_agent.max_neighbors = 10
	_agent.time_horizon = 20
	_agent.max_speed = 350
	add_child(_agent)
	var _collision_shape = CollisionShape2D.new()
	_collision_shape.shape = CircleShape2D.instance()
	_collision_shape.shape.radius = 50
	add_child(_collision_shape)
