class_name Champion 
extends Dancer


func get_rnd_target() -> void:
	var beacons = get_tree().get_nodes_in_group("Beacons")
	var beacon = Global.get_random_element(beacons)
	beacon._sprite.modulate = Color.red
	beacon._sprite.visible = true
	#print("rnd",beacon.global_position)
	_target_move = beacon

func set_target_move(type_: String = "classic") -> void:
	match type_:
		"classic":
			get_rnd_target()
	
