extends Node


var rng = RandomNumberGenerator.new()
var dict = {}
var arr = {}
var node = {}

func init_dict():
	init_window_size()
	
	dict.windrose = {
		"N":  Vector2( 0, -1),
		"NE": Vector2( 1, -1),
		"E":  Vector2( 1, 0),
		"SE": Vector2( 1, 1),
		"S":  Vector2( 0, 1),
		"SW": Vector2(-1, 1),
		"W":  Vector2(-1, 0),
		"NW": Vector2(-1,-1)
	}
	
	dict.reflected_windrose = {}
	var n = dict.windrose.keys().size()
	
	for _i in n:
		var _j = (_i+n/2)%n
		dict.reflected_windrose[dict.windrose.keys()[_i]] = dict.windrose.keys()[_j]

func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)
	
	OS.set_current_screen(1)

func init_arr():
	arr.layer = [1,2,4,5,20]

func init_node():
	node.ballroom = get_node("/root/Game/Ballroom") 

func _ready():
	init_dict()
	init_arr()
	init_node()


func get_random_element(arr_):
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]
