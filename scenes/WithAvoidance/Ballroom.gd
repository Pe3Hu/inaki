extends Node2D


var _border_offset := Vector2(2,2)
var _grid_size := Vector2(21,21)
var _beacon_position = {}

onready var _navigation: Navigation2D = $Navigation
onready var _tilemap: TileMap = $TileMap
var _beacon = preload("res://scenes/Beacon/Beacon.tscn")

func _ready():
	_init_tilemap_border()
	_init_beacons()
	pass # Replace with function body.

func _init_tilemap_border():
	var grids = []
	
	for x in _border_offset.x*2+_grid_size.x:
		for y in _border_offset.y*2+_grid_size.y:
			if x < _border_offset.x || x > _grid_size.x+1 || y < _border_offset.x || y > _grid_size.x+1:
				grids.append(Vector2(x,y))
	
	for grid in grids:
		_tilemap.set_cellv(grid,0)
	
	_tilemap.update_bitmask_region(grids.front(),grids.back())

func _init_beacons() -> void:
	for _i in _grid_size.x:
		for _j in _grid_size.y:
			var input = {}
			input.grid = Vector2(_j,_i)
			
			var beacon = _beacon.instance()
			_navigation.add_child(beacon)
			beacon._set_vars(input)
	
	for beacon in _navigation.get_children():
		if beacon.get_class() == "NavigationPolygonInstance":
			_beacon_position[beacon.position] = beacon
	
	for key in _beacon_position.keys():
		var beacon = _beacon_position[key]
		
		for layer in beacon._neighbor.keys():
			for windrose in Global.dict.windrose:
				var l = beacon._size_current*Global.arr.layer.back()/layer
				
				if windrose.length() == 1:
					l *= 2
				
				var shift = Global.dict.windrose[windrose]*l
				var position = beacon.position+shift
				
				if _beacon_position.keys().has(position):
					var neighbor = _beacon_position[position]
						
					if !neighbor._neighbor.has(layer):
						neighbor._neighbor[layer] = {}
					
					#beacon._neighbor[layer][windrose] = neighbor
					#neighbor._neighbor[layer][Global.dict.reflected_windrose[windrose]] = beacon
	
	for key in _beacon_position.keys():
		var beacon = _beacon_position[key]
		
		if beacon._neighbor.keys().has(5):
#		for layer in beacon._neighbor.keys():
#			for windrose in beacon._neighbor[layer].keys():
			beacon._sprite.visible = true
