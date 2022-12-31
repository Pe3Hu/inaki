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


func set_spirtes(data_) -> void:
#	obj.card = data_
#	obj.pas = data_.obj.pas 
#	obj.exam = data_.obj.exam 
#	for key in Global.arr.sprite.card:
#		var sprite = get_node(key)
#		var path = "res://assets/"
#		var name_ = ".png"
#
#		match key:
#			"Chesspiece":
#				path = path+"effects/move/"
#				name_ = obj.pas.word.chesspiece+name_
#			"Layer":
#				path = path+"layers/square/"
#				name_ = str(obj.pas.num.layer)+name_
#			"Exam":
#				var team = obj.card.obj.dancer.obj.troupe.word.team
#				path = path+"effects/exam/"+team+"/"
#				name_ = obj.exam.word.name+name_
#			"Border":
#				path = path+"cards/"
#				name_ = border+name_
#
#		sprite.texture = load(path+name_)
	pass


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
	print(data_)
