class_name Mob
extends Dancer


func set_target_move(type_: String = "classic") -> void:
	match type_:
		"by pas":
			var opponents = get_tree().get_nodes_in_group(opponent)
			target_move = opponents.front()
		"classic":
			var opponents = get_tree().get_nodes_in_group(opponent)
			target_move = opponents.front()
		"last beacon":
			target_move = beacons.back()
			
			if beacons.back().dancers.size() > 1:
				target_move = beacons.front()


