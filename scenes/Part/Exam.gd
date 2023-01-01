extends Node2D
class_name Exam


var dancer
var part
var byname


func set_spirte() -> void:
	var team = dancer.team
	var sprite = get_node("ExamSprite")
	var path = "res://assets/exams/"+team+"/"
	var name_ = byname+".png"
	sprite.texture = load(path+name_)
	sprite.scale = Global.dict.window_size.scale*2


func set_vars(data_):
	dancer = data_.dancer
	part = data_.part
	byname = data_.byname
	
	if dancer.team == "Champions":
		set_spirte()
