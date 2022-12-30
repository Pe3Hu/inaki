class_name Mob
extends Dancer


func _set_target(type_: String = "classic") -> void:
	match type_:
		"classic":
			var opponents = get_tree().get_nodes_in_group(_opponent)
			_target = opponents.front()
		"last beacon":
			_target = _beacons.front()
			
			if _beacons.front()._bodys.size() > 1:
				_target = _beacons.back()

