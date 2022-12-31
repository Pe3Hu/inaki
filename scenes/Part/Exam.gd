extends Node2D
class_name Exam


var dancer
var part
var byname


func set_spirtes() -> void:
	var team = dancer.team
	var sprite = get_node("ExamSprite")
	var path = "res://assets/exams/"+team+"/"
	var name_ = byname+".png"
	sprite.texture = load(path+name_)


func set_vars(data_):
	dancer = data_.dancer
	part = data_.part
	byname = data_.byname
	set_spirtes()
