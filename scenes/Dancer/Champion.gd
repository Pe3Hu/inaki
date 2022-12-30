class_name Champion 
extends Dancer


var _resource_current := 0
var _resource_max := 0

func _init(data_).(data_):
	_resource_max = data_.resource 
	_resource_current = _resource_max

func _get_rnd_target() -> void:
	var beacons = get_tree().get_nodes_in_group("Beacons")
	var beacon = Global.get_random_element(beacons)
	beacon._sprite.modulate = Color.red
	beacon._sprite.visible = true
	print("rnd",beacon.global_position)
	_target = beacon

func _set_target(type_: String = "classic") -> void:
	match type_:
		"classic":
			_get_rnd_target()
	
