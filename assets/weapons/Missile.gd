class_name Missile
extends Node2D

const LAUNCH_SPEED := 1800.0

export var lifetime := 20.0

var max_speed := 500.0
var drag_factor := 0.15 setget set_drag_factor

var _target

var _current_velocity := Vector2.ZERO

onready var _sprite := $Sprite
onready var _hitbox := $HitBox
onready var _dancer_detector := $DancerDetector

func _ready():
	set_as_toplevel(true)
	
	_hitbox.connect("body_entered", self, "_on_HitBox_body_entered")
	# Detects a target to lock on within a large radius.
	_dancer_detector.connect("body_entered", self, "_on_DancerDetector_body_entered")
	
	var timer := get_tree().create_timer(lifetime)
	timer.connect("timeout", self, "queue_free")
	
	_current_velocity = max_speed * 5 * Vector2.RIGHT.rotated(rotation)


func _physics_process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	
	if _target:
		direction = global_position.direction_to(_target.global_position)
	
	var desired_velocity := direction * max_speed
	var previous_velocity = _current_velocity
	var change = (desired_velocity - _current_velocity) * drag_factor
	
	_current_velocity += change
	
	position += _current_velocity * delta
	look_at(global_position + _current_velocity)


func set_drag_factor(new_value: float) -> void:
	drag_factor = clamp(new_value, 0.01, 0.5)


func _on_HitBox_body_entered(_body: Node) -> void:
	queue_free()


func _on_DancerDetector_body_entered(dancer):
	if _target != null:
		return
		
	if dancer == null:
		return
		
	_target = dancer
