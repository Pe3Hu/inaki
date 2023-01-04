extends Node


onready var ballroom: Node2D = $Ballroom
onready var interfaces: CanvasLayer = $Interfaces
onready var bars: Control = $Interfaces/Bars

func _ready():
	set_offsets()
	set_bars()

func set_offsets() -> void:
	var l = Global.dict.window_size.center.x
	l -= ballroom.BEACON_SIZE.x*(ballroom.GRID_SIZE.x+ballroom.BORDER_OFFSET.x*2)/2*ballroom.scale.x
	l = round(l)
	ballroom.position.x = l
	
	var dancers = {
		"Mobs": 1,
		"Champions": 1
	}
	var resize = 0.9
	var border = (1-resize)*l
	
	for team in dancers.keys():
		var path = "res://scenes/UI/interface/"+team+"Interface.tscn"
		var scene = load(path)
		var new_interface = scene.instance()
		
		for _i in dancers[team]:
			new_interface = scene.instance()
			bars.get_node(team).add_child(new_interface)
			
		bars.get_node(team).rect_scale = Vector2.ONE*l/new_interface.rect_size.x*resize
		
		match team:
			"Champions":
				bars.get_node(team).rect_position = Vector2.ONE*border
			"Mobs":
				bars.get_node(team).rect_position.x = Global.dict.window_size.width-border-new_interface.rect_size.x*bars.get_node(team).rect_scale.x
				bars.get_node(team).rect_position.y = border
		#bars.get_node(team).rect_position *= bars.get_node(team).rect_scale


func set_bars() -> void:
	pass
