extends Node


onready var ballroom: Node2D = $Ballroom
onready var interfaces: CanvasLayer = $Interfaces
onready var bars: HBoxContainer = $Interfaces/ReferenceRect/Bars

func _ready():
	set_offsets()

func set_offsets() -> void:
	var l = Global.dict.window_size.center.x
	l -= ballroom.BEACON_SIZE.x*(ballroom.GRID_SIZE.x+ballroom.BORDER_OFFSET.x*2)/2*ballroom.scale.x
	l = round(l)
	ballroom.position.x = l
	
	
	var resize = 0.9
	var border = (1-resize)*l
	var interface = bars.get_child(0)
	interfaces.scale = Vector2.ONE*l/interface.rect_size.x*resize
#	interfaces.get_node("Champions").rect_position = Vector2.ONE*border
#
#	interfaces.get_node("Mobs").rect_position.x = Global.dict.window_size.width*2-border
#	interfaces.get_node("Mobs").rect_position.y = border
