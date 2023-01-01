class_name Champion 
extends Dancer


func get_rnd_target() -> void:
	var beacons = get_tree().get_nodes_in_group("Beacons")
	var beacon = Global.get_random_element(beacons)
	beacon.sprite.modulate = Color.red
	beacon.sprite.visible = true
	#rint("rnd",beacon.global_position)
	target_move = beacon


func set_target_move(type_: String = "classic") -> void:
	match type_:
		"by pas":
			target_move = ballroom.croupier.card.pas.beacon

