class_name Beacon
extends Area2D


const BORDER_OFFSET := Vector2(2,2)
const SIZE_ORIGINAL := Vector2(64,64)

var SIZE_CURRENT := Vector2(80,80)
var GRID := Vector2.ZERO
var neighbors = {}
var dancers = []

onready var sprite := $Sprite


func set_vars(data_: Dictionary) -> void:
	SIZE_CURRENT *= Global.dict.window_size.scale
	var shift = Vector2(0.5,0.5)
	GRID = data_.grid
	position = (GRID + BORDER_OFFSET + shift)*SIZE_CURRENT
	scale = SIZE_CURRENT/SIZE_ORIGINAL
	#position = get_parent().get_parent()._tilemap.map_to_world(grid)
	
	for layer in Global.arr.layer:
		if int(GRID.x)%layer == 0 && int(GRID.y)%layer == 0:
			neighbors[layer] = {}


func _on_TextureButton_pressed():
	#print ("get_global_mouse_position" , get_global_mouse_position())       
	#print ("event.global_position" , event.global_position)  
	#print(global_position,position)
	pass


func _on_Beacon_body_exited(body):
	dancers.erase(body)
	
	if body.beacons.size() > 2:
		body.beacons.pop_front()


func _on_Beacon_body_entered(body):
	dancers.append(body)
	body.beacons.append(self)
