extends Node


var rng = RandomNumberGenerator.new()
var dict = {}
var arr = {}
var node = {}
signal enemy_hit


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
	
	dict.opponent = {
		"Mobs": "Champions",
		"Champions": "Mobs"
	}
	
	dict.ancor = {
		"Mobs": Vector2(1,0),
		"Champions": Vector2(0,0),
	}
	
	dict.feature = {}
	dict.feature.base = {
		"champion_0": {
			"team": "Champions",
			"health": 100,
			"resource": 100,
			"deftness": 1,
			"swiftness": 1,
			"cockiness": 1,
			"pas_draw": 4,
			"exam_draw": 5
		},
		"mob_0": {
			"team": "Mobs",
			"health": 1000,
			"deftness": 2,
			"swiftness": 1,
			"cockiness": 1,
			"pas_draw": 1,
			"exam_draw": 1
		}
	}
	
	dict.chesspiece = {
		"Champions" : ["queen","rook","rook","bishop","bishop","knight","knight","knight","knight"],
		"Mobs" : ["cat"]
	}
	dict.exam = {
		"champion_0": ["exam_0","exam_0","exam_0","exam_0","exam_0","exam_1","exam_1","exam_1","exam_1","exam_2"],
		"mob_0": ["exam_1000"]
	}


func init_window_size():
	dict.window_size = {}
	dict.window_size.width = ProjectSettings.get_setting("display/window/size/width")
	dict.window_size.height = ProjectSettings.get_setting("display/window/size/height")
	dict.window_size.center = Vector2(dict.window_size.width/2, dict.window_size.height/2)
	dict.window_size.scale = Vector2(0.4,0.4)
	
	OS.set_current_screen(1)


func init_arr():
	arr.layer = [2,4,6,12]
	arr.champion_layer = [2,4,6,12]
	arr.part = ["exam","pas"]
	arr.stack = ["deck","discard","hand","exile","option"]


func init_node():
	node.ballroom = get_node(".") 


func _ready():
	init_dict()
	init_arr()
	init_node()


func get_random_element(arr_):
	rng.randomize()
	var index_r = rng.randi_range(0, arr_.size()-1)
	return arr_[index_r]
