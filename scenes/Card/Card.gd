extends Area2D
class_name Card2D


const ZOOM := Vector2(1.5,1.5)
const SIZE := Vector2(80,120)
var BASE_SCALE := Vector2.ZERO

var border: String = "access"
var croupier
var pas
var exam
var temp


func set_spirte() -> void:
	var sprite = get_node("BorderSprite")
	var path = "res://assets/cards/"
	var name_ = border+".png"
	sprite.texture = load(path+name_)


func _on_Card_mouse_entered() -> void:
	croupier.push_card_on_top(self)


func _on_Card_mouse_exited() -> void:
	scale = BASE_SCALE


func _on_Card_input_event(viewport, event, shape_idx) -> void:
	if (event is InputEventMouseButton && event.pressed):
		if border == "access":
			croupier.ballroom.set_pas_beacon(pas)
			croupier.card = self


func zoom() -> void:
	scale = BASE_SCALE*ZOOM


func unzoom() -> void:
	scale = BASE_SCALE


func set_vars(data_) -> void:
	pas = data_.pas
	exam = data_.exam
	temp = data_.temp
	croupier = data_.croupier
	add_child(pas)
	add_child(exam)
	check_access()
	
	if pas.dancer.team == "Champions":
		set_spirte()


func preuse() -> void:
	for card in croupier.card_stack:
		card.temp = false
	
	temp = true


func check_access() -> void:
	if pas.dancer.beacons.back().neighbors.keys().has(pas.layer):
		border = "access"
	else:
		border = "denied"

