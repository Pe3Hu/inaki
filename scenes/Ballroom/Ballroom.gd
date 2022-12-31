extends Node2D


const BORDER_OFFSET := Vector2(2,2)
const GRID_SIZE := Vector2(13,13)
const BEACON_SIZE := Vector2(80,80)

var grid_center := Vector2.ZERO
var beacon_positions = {}
var _d := 0

export var freeze_slow := 0.1
export var freeze_time := 0.5

onready var navigation: Navigation2D = $Navigation
onready var tilemap: TileMap = $TileMap
onready var beacons: Node = $Beacons
onready var croupier: Node2D = $"Сroupier"

onready var beacon_scene = preload("res://scenes/Beacon/Beacon.tscn")
onready var dancer_scene = preload("res://scenes/Dancer/Dancer.tscn")
onready var mob_scene = preload("res://scenes/Dancer/Mob.tscn")
onready var champion_scene = preload("res://scenes/Dancer/Champion.tscn")


func _ready():
	Global.connect("enemy_hit", self, "freeze_engine")
	grid_center.x += floor(GRID_SIZE.x/2)
	grid_center.y += floor(GRID_SIZE.y/2)
	grid_center += BORDER_OFFSET
	init_tilemap_border()
	init_beacons()
	init_dancers()
	scale = Global.dict.window_size.scale
	_d = BEACON_SIZE.length()/2
	var grid = Vector2(GRID_SIZE+BORDER_OFFSET*2.5)
	grid.x +=1
	croupier.position = tilemap.map_to_world(grid)


func init_tilemap_border() -> void:
	var grids = []
	
	for x in BORDER_OFFSET.x*2+GRID_SIZE.x:
		for y in BORDER_OFFSET.y*2+GRID_SIZE.y:
			if x < BORDER_OFFSET.x || x > GRID_SIZE.x+1 || y < BORDER_OFFSET.x || y > GRID_SIZE.x+1:
				grids.append(Vector2(x,y))
	
	for grid in grids:
		tilemap.set_cellv(grid,0)
	
	tilemap.update_bitmask_region(grids.front(),grids.back())


func init_beacons() -> void:
	var a = BEACON_SIZE.x/2
	
	for _i in GRID_SIZE.x:
		for _j in GRID_SIZE.y:
			var data = {}
			data.grid = Vector2(_j,_i)
			data.ballroom = self
			var new_beacon = beacon_scene.instance()
			beacons.add_child(new_beacon)
			new_beacon.set_vars(data)
			
			var navpoly = NavigationPolygonInstance.new()
			var polygon = NavigationPolygon.new()
			var vertices = PoolVector2Array([Vector2(a, -a), Vector2(a, a), Vector2(-a, a), Vector2(-a, -a)])
			
			for _k in vertices.size():
				vertices[_k] += tilemap.map_to_world(new_beacon.GRID+new_beacon.BORDER_OFFSET)
				vertices[_k] += Vector2(a, a)
			
			polygon.set_vertices(vertices)
			var indices = PoolIntArray([0, 1, 2, 3])
			polygon.add_polygon(indices)
			navpoly.navpoly = polygon
			navigation.add_child(navpoly)
	
	for beacon in beacons.get_children():
		if beacon.get_class() == "Area2D":
			beacon_positions[beacon.position] = beacon
	
	for layer in Global.arr.layer:
		for key in beacon_positions.keys():
			var beacon = beacon_positions[key]
			
			if beacon.neighbors.keys().has(layer):
				for windrose in Global.dict.windrose:
					var l = beacon.SIZE_CURRENT*layer
					
					if windrose.length() == 2:
						l /= 2
					
					var shift = Global.dict.windrose[windrose]*l
					var position = beacon.position+shift
					
					if beacon_positions.keys().has(position):
						var neighbor = beacon_positions[position]
						
						if !neighbor.neighbors.has(layer):
							neighbor.neighbors[layer] = {}
						
						beacon.neighbors[layer][windrose] = neighbor
						neighbor.neighbors[layer][Global.dict.reflected_windrose[windrose]] = beacon
	
	set_layer(4)


func init_dancers() -> void:
	for byname in Global.dict.feature.base.keys():
		var data = Global.dict.feature.base[byname]
		data.byname = byname
		data.ballroom = self
		var dancer
		
		match data.team:
			"Champions":
				dancer = champion_scene.instance()
			"Mobs":
				dancer = mob_scene.instance()
		
		dancer.set_vars(data)
		
		navigation.add_child(dancer)
	
	
	spread_opponents()
	
#	for dancer in navigation.get_children():
#		if dancer.get_class() != "Area2D":
#			#pint(dancer.get_class())
#			dancer._find_target_path()
	pass


func spread_opponents() -> void:
	for team in Global.dict.opponent.keys():
		var dancers = get_tree().get_nodes_in_group(team)
		var y = dancers.size()/2
		var grid = Global.dict.ancor[team]*4 + grid_center - Vector2(0,y)
		
		for dancer in dancers:
			dancer.update_target_exam()
			dancer.position = tilemap.map_to_world(grid)+BEACON_SIZE/2
			grid += Vector2(0,1)


func set_layer(layer_: int) -> void:
	for key in beacon_positions.keys():
		var beacon = beacon_positions[key]
		beacon.sprite.visible = beacon.neighbors.keys().has(layer_)


func freeze_engine() -> void:
	Engine.time_scale = freeze_slow
	yield(get_tree().create_timer(freeze_time * freeze_slow), "timeout")
	Engine.time_scale = 1

#func _process(delta_):
#	update()
#
#func _draw():
#	for navpoly in navigation.get_children():
#		if navpoly.get_class() == "NavigationPolygonInstance":
#			draw_polygon(navpoly.navpoly.get_vertices(), PoolColorArray([Color.black]))
