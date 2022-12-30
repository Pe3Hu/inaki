class_name Beacon
extends Area2D


var _border_offset := Vector2(2,2)
var _size_original := Vector2(64,64)
var _size_current := Vector2(80,80)
var _grid := Vector2.ZERO
var _neighbor = {}

onready var _sprite := $Sprite


func _ready() -> void:
	pass


func _set_vars(data_: Dictionary) -> void:
	_size_current *= Global.dict.window_size.scale
	var shift = Vector2(0.5,0.5)
	_grid = data_.grid
	position = (_grid + _border_offset + shift)*_size_current
	scale = _size_current/_size_original
	#position = get_parent().get_parent()._tilemap.map_to_world(_grid)
	
	for layer in Global.arr.layer:
		if int(_grid.x)%layer == 0 && int(_grid.y)%layer == 0:
			_neighbor[layer] = {}


func _on_TextureButton_pressed():
	#print ("get_global_mouse_position" , get_global_mouse_position())       
	#print ("event.global_position" , event.global_position)  
	#print(global_position,position)
	pass


func _on_Beacon_body_exited(body):
	body._beacon = self
