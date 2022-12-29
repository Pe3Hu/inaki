extends Node2D


var _border_offset := Vector2(2,2)
var _grid_size := Vector2(13,13)
var _grid_center := Vector2.ZERO
var _beacon_position = {}

onready var _navigation: Navigation2D = $Navigation
onready var _tilemap: TileMap = $TileMap
var _beacon = preload("res://scenes/Beacon/Beacon.tscn")


func _ready():
	_grid_center.x += floor(_grid_size.x/2)
	_grid_center.y += floor(_grid_size.y/2)
	_grid_center += _border_offset
	_init_tilemap_border()
	_init_beacons()
	_init_dancers()


func _init_tilemap_border() -> void:
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
	
	for layer in Global.arr.layer:
		for key in _beacon_position.keys():
			var beacon = _beacon_position[key]
			
			if beacon._neighbor.keys().has(layer):
				for windrose in Global.dict.windrose:
					var l = beacon._size_current*layer
					
					if windrose.length() == 2:
						l /= 2
					
					var shift = Global.dict.windrose[windrose]*l
					var position = beacon.position+shift
					
					if _beacon_position.keys().has(position):
						var neighbor = _beacon_position[position]
						
						if !neighbor._neighbor.has(layer):
							neighbor._neighbor[layer] = {}
						
						beacon._neighbor[layer][windrose] = neighbor
						neighbor._neighbor[layer][Global.dict.reflected_windrose[windrose]] = beacon
	
	print(_navigation.get_children().front().global_position)
	print(_navigation.get_children().back().global_position)
	_set_layer(2)


func _init_dancers() -> void:
	for name_ in Global.dict.feature.base.keys():
		var data = Global.dict.feature.base[name_]
		data.name = name_
		var dancer
		
		match data.team:
			"Champions":
				dancer = Champion.new(data)
			"Mobs":
				dancer = Mob.new(data)
				
		_navigation.add_child(dancer)
	
	
	_spread_opponents()
	
#	for dancer in _navigation.get_children():
#		if dancer.get_class() != "NavigationPolygonInstance":
#			#pint(dancer.get_class())
#			dancer._find_target_path()
	

func _spread_opponents() -> void:
	var beacon_size
	
	for beacon in _navigation.get_children():
		if beacon.get_class() == "NavigationPolygonInstance": 
			beacon_size = beacon._size_current
	
	for team in Global.dict.opponent.keys():
		var dancers = get_tree().get_nodes_in_group(team)
		var y = dancers.size()/2
		var grid = Global.dict.ancor[team]*4 + _grid_center - Vector2(0,y)
		
		for dancer in dancers:
			dancer.position = _tilemap.map_to_world(grid)+beacon_size/2
			grid += Vector2(0,1)

func _set_layer(layer_: int) -> void:
	for key in _beacon_position.keys():
		var beacon = _beacon_position[key]
		beacon._sprite.visible = beacon._neighbor.keys().has(layer_)
