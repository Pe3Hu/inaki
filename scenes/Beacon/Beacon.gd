class_name Beacon
extends Area2D


const BORDER_OFFSET := Vector2(2,2)
const SIZE_ORIGINAL := Vector2(64,64)

var SIZE_CURRENT := Vector2(80,80)
var GRID := Vector2.ZERO
var neighbors = {}
var dancers = []
var selected_color = {
	false: Color.white,
	true: Color.black
}

var ballroom
onready var sprite := $Sprite


func set_vars(data_: Dictionary) -> void:
	var shift = Vector2(0.5,0.5)
	GRID = data_.grid
	ballroom = data_.ballroom
	position = (GRID + BORDER_OFFSET + shift)*SIZE_CURRENT
	#scale = SIZE_CURRENT/SIZE_ORIGINAL
	
	for layer in Global.arr.layer:
		if int(GRID.x)%layer == 0 && int(GRID.y)%layer == 0:
			neighbors[layer] = {}


func _on_Beacon_body_exited(body):
	dancers.erase(body)
	
	if body.beacons.size() > 2:
		body.beacons.pop_front()


func _on_Beacon_body_entered(body):
	dancers.append(body)
	body.beacons.append(self)


func _on_Beacon_input_event(viewport, event, shape_idx) -> void:
	if (event is InputEventMouseButton && event.pressed):
		ballroom.croupier.card.pas.beacon = self
		ballroom.croupier.card.preuse()
		ballroom.croupier.fix_temp()


func _on_Beacon_mouse_entered():
	sprite.modulate = selected_color[true]


func _on_Beacon_mouse_exited():
	sprite.modulate = selected_color[false]
