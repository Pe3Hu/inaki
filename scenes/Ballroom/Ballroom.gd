extends Node2D


var _border_offset := Vector2(2,2)
var _grid_size := Vector2(13,13)
var _grid_center := Vector2.ZERO
var _beacon_size := Vector2(80,80)
var _beacon_position = {}
var _d := 0

onready var _navigation: Navigation2D = $Navigation
onready var _tilemap: TileMap = $TileMap
onready var _beacons: Node = $Beacons
onready var _beacon = preload("res://scenes/Beacon/Beacon.tscn")
onready var _dancer = preload("res://scenes/Dancer/Dancer.tscn")
onready var _mob = preload("res://scenes/Dancer/Mob.tscn")
onready var _champion = preload("res://scenes/Dancer/Champion.tscn")


func _ready():
	_grid_center.x += floor(_grid_size.x/2)
	_grid_center.y += floor(_grid_size.y/2)
	_grid_center += _border_offset
	init_tilemap_border()
	init_beacons()
	init_dancers()
	scale = Global.dict.window_size.scale
	_d = _beacon_size.length()/2


func init_tilemap_border() -> void:
	var grids = []
	
	for x in _border_offset.x*2+_grid_size.x:
		for y in _border_offset.y*2+_grid_size.y:
			if x < _border_offset.x || x > _grid_size.x+1 || y < _border_offset.x || y > _grid_size.x+1:
				grids.append(Vector2(x,y))
	
	for grid in grids:
		_tilemap.set_cellv(grid,0)
	
	_tilemap.update_bitmask_region(grids.front(),grids.back())


func init_beacons() -> void:
	var a = _beacon_size.x/2
	
	for _i in _grid_size.x:
		for _j in _grid_size.y:
			var data = {}
			data.grid = Vector2(_j,_i)
			data.ballroom = self
			var beacon = _beacon.instance()
			_beacons.add_child(beacon)
			beacon.set_vars(data)
			
			var navpoly = NavigationPolygonInstance.new()
			var polygon = NavigationPolygon.new()
			var vertices = PoolVector2Array([Vector2(a, -a), Vector2(a, a), Vector2(-a, a), Vector2(-a, -a)])
			for _k in vertices.size():
				vertices[_k] += _tilemap.map_to_world(beacon._grid+beacon._border_offset)
				vertices[_k] += Vector2(a, a)
			
			polygon.set_vertices(vertices)
			var indices = PoolIntArray([0, 1, 2, 3])
			polygon.add_polygon(indices)
			navpoly.navpoly = polygon
			_navigation.add_child(navpoly)
	
	for beacon in _beacons.get_children():
		if beacon.get_class() == "Area2D":
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
	
	set_layer(4)


func init_dancers() -> void:
	for name_ in Global.dict.feature.base.keys():
		var data = Global.dict.feature.base[name_]
		data.name = name_
		data.ballroom = self
		var dancer
		
		match data.team:
			"Champions":
				dancer = _champion.instance()
				dancer._ready()
			"Mobs":
				dancer = _mob.instance()
				dancer._ready()
		
		dancer.set_vars(data)
		
		_navigation.add_child(dancer)
	
	
	spread_opponents()
	
#	for dancer in _navigation.get_children():
#		if dancer.get_class() != "Area2D":
#			#pint(dancer.get_class())
#			dancer._find_target_path()
	pass


func spread_opponents() -> void:
	for team in Global.dict.opponent.keys():
		var dancers = get_tree().get_nodes_in_group(team)
		var y = dancers.size()/2
		var grid = Global.dict.ancor[team]*4 + _grid_center - Vector2(0,y)
		
		for dancer in dancers:
			dancer.update_target_exam()
			dancer.position = _tilemap.map_to_world(grid)+_beacon_size/2
			grid += Vector2(0,1)


func set_layer(layer_: int) -> void:
	for key in _beacon_position.keys():
		var beacon = _beacon_position[key]
		beacon._sprite.visible = beacon._neighbor.keys().has(layer_)


#func _process(delta_):
#	update()
#
#func _draw():
#	for navpoly in _navigation.get_children():
#		if navpoly.get_class() == "NavigationPolygonInstance":
#			draw_polygon(navpoly.navpoly.get_vertices(), PoolColorArray([Color.black]))
