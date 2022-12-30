class_name Mob
extends Dancer


func set_target_move(type_: String = "classic") -> void:
	match type_:
		"classic":
			var opponents = get_tree().get_nodes_in_group(_opponent)
			_target_move = opponents.front()
		"last beacon":
			_target_move = _beacons.back()
			print(_beacons.back()._bodys.size())
			
			if _beacons.back()._bodys.size() > 1:
				_target_move = _beacons.front()

