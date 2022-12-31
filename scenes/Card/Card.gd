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


func set_spirtes() -> void:
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
#		if border == "access":
#			Global.current.pas = obj.pas
#			Global.set_square_layer(obj.pas.num.layer)
#			Global.obj.ballroom.get_dots_by_pas()
#			Global.current.dot = null
		pass


func zoom() -> void:
	scale = BASE_SCALE*ZOOM


func unzoom() -> void:
	scale = BASE_SCALE


func set_vars(data_) -> void:
	pas = data_.pas
	exam = data_.exam
	temp = data_.temp
	croupier = data_.croupier


func preuse() -> void:
	for card in croupier.card_stack:
		card.temp = false
	
	temp = true
