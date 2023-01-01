class_name Dancer
extends KinematicBody2D


const missile_scene := preload("res://assets/weapons/Missile.tscn")
const damage_label_scene := preload("res://scenes/DamageLabel/DamageLabel.tscn")
const pas_scene := preload("res://scenes/Part/Pas.tscn")
const exam_scene := preload("res://scenes/Part/Exam.tscn")

var velocity := Vector2.ZERO
var byname := String()
var team := String()
var opponent := String()
var color := Color()
var health_current := 0
var health_max := 0
var resource_current := 0
var resource_max := 0
var deftness_current := 0
var deftness_max := 0
var swiftness_current := 0
var swiftness_max := 0
var cockiness_current := 0
var cockiness_max := 0
var print_timer := false

onready var travel_speed_slider := 100
onready var drag_factor_slider := 0.1

onready var agent: NavigationAgent2D = $NavigationAgent2D
onready var waitng_timer: Timer = $WatingTimer
onready var moving_timer: Timer = $MovingTimer
onready var parking_timer: Timer = $ParkingTimer
onready var examing_timer: Timer = $ExamingTimer
onready var sprite: Sprite = $Sprite
onready var shoot_position: Position2D = $Sprite/ShootPosition
onready var damage_spawning_point := $DamageSpawningPoint
onready var examing_progress_display: ProgressBar = $ExamingProgressBar

var target_move
var target_exam
var ballroom
var beacons := []
var part = {}
var stun := false

func _ready():
	waitng_timer.connect("timeout", self, "start_moving")#"")
	moving_timer.connect("timeout", self, "update_pathfinding")
	parking_timer.connect("timeout", self, "start_examing")
	examing_timer.connect("timeout", self, "end_examing")
	agent.connect("velocity_computed", self, "move")
	
	agent.max_speed = 80 * deftness_current
	set_sprite()
	init_pass()
	init_exams()
	
	examing_timer.wait_time = 0.1


func _physics_process(delta: float) -> void:
	if moving_timer.is_stopped():
		return
	
	match team:
		"Mobs":
			if ballroom._d/2 > agent.distance_to_target():
				set_target_move("last beacon")
				start_parking()
		"Champions":
			if agent.is_navigation_finished():
				start_parking()
	
	var target_global_position := agent.get_next_location()
	var direction := global_position.direction_to(target_global_position)
	var desired_velocity := direction * agent.max_speed
	var steering := (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	agent.set_velocity(velocity)


func move(velocity: Vector2) -> void:
#	for i in get_slide_count():
#		var collision = get_slide_collision(i)
	velocity = move_and_slide(velocity)
	sprite.rotation = lerp_angle(sprite.rotation, velocity.angle(), 10.0 * get_physics_process_delta_time())


func update_pathfinding() -> void:
	agent.set_target_location(target_move.global_position)


func set_target_move(type_: String = "classic") -> void:
	pass


func start_moving() -> void:
	select_card()
	if team == "Champions" && print_timer:
		print("_start_moving")
	waitng_timer.stop()
	moving_timer.start()


func start_parking() -> void:
	if team == "Champions" && print_timer:
		print("_parking")
	moving_timer.stop()
	parking_timer.start()
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_move.global_position, parking_timer.get_wait_time())


func start_examing() -> void:
	parking_timer.stop()
	examing_timer.start()
	
	examing_progress_display.show()
	var tween := create_tween()
	examing_progress_display.value = 0.0
	tween.tween_property(examing_progress_display, "value", 1.0, examing_timer.wait_time)
	var angle =  global_position.direction_to(target_exam.global_position)
	
	tween.parallel().tween_property(sprite, "rotation", angle.angle(), examing_timer.wait_time)
	if team == "Champions" && print_timer:
		print("_examing")


func end_examing() -> void:
	examing_progress_display.hide()
	shoot()
	start_waiting()


func start_waiting() -> void:
	examing_timer.stop()
	waitng_timer.start()
	if team == "Champions" && print_timer:
		print("_waiting")


func shoot() -> void:
	var new_missile := missile_scene.instance() as Missile
	#missile.drag_factor = _drag_factor_slider
	#missile.max_speed = _travel_speed_slider
	new_missile._target = target_exam
	new_missile.global_position = shoot_position.global_position
	new_missile.rotation = sprite.rotation
	add_child(new_missile)


func update_target_exam() -> void:
	var opponents = get_tree().get_nodes_in_group(opponent)
	target_exam = opponents.front()


func take_damage(amount: int) -> void:
	health_current = max(0, health_current - amount)
	var label := damage_label_scene .instance()
	label.global_position = damage_spawning_point.global_position
	label.set_damage(amount)
	Global.emit_signal("enemy_hit")
	add_child(label)


func set_vars(data_: Dictionary) -> void:
	ballroom = data_.ballroom
	byname = data_.byname
	team = data_.team 
	opponent = Global.dict.opponent[team]
	health_max = data_.health 
	health_current = health_max
	
	if data_.keys().has("resource"):
		resource_max = data_.resource 
		resource_current = resource_max
	
	deftness_max = data_.deftness 
	deftness_current = deftness_max
	swiftness_max = data_.swiftness 
	swiftness_current = swiftness_max
	cockiness_max = data_.cockiness 
	cockiness_current = cockiness_max
	add_to_group(team)
	
	for key in Global.arr.part:
		part[key] = {}
			
		for key_ in Global.arr.stack:
			part[key][key_] = []
		
		part[key].empty = false
	
	part.pas.draw = data_.pas_draw
	part.exam.draw = data_.exam_draw


func set_sprite() -> void:
	var path = "res://assets/dancer/"
	var name_ = team+"_arrow.png"
	sprite.texture = load(path+name_)
	
	match team:
		"Mobs":
			color = Color.purple
		"Champions":
			color = Color.green
	
	sprite.modulate = color


func init_pass() -> void:
	var data = {}
	data.dancer = self
	data.part = "pas"
	
	for chesspiece in Global.dict.chesspiece[team]:
		data.chesspiece = chesspiece
		data.layer = Global.get_random_element(Global.arr.champion_layer)
		var new_pas = pas_scene.instance()
		new_pas.set_vars(data)
		part[data.part].discard.append(new_pas)
	
	if team == "Champions":
		data.chesspiece = "king"
		data.layer = 2
		var new_pas = pas_scene.instance()
		new_pas.set_vars(data)
		part[data.part].discard.append(new_pas)


func init_exams() -> void:
	var data = {}
	data.dancer = self
	data.part = "exam"
	
	for exam_byname in Global.dict.exam[byname]:
		data.byname = exam_byname
		var new_exam = exam_scene.instance()
		new_exam.set_vars(data)
		part[data.part].discard.append(new_exam)


func select_card() -> void:
	get_tree().paused = true
	ballroom.croupier.dancer = self
	ballroom.croupier.fill_hand()
	
	if team == "Mobs":
		autoselect()


func autoselect():
	var card = Global.get_random_element(ballroom.croupier.card_stack)
	ballroom.croupier.card = card
	card.preuse()
	ballroom.croupier.fix_temp()
