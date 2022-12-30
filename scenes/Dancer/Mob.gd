class_name Mob
extends Dancer


func _init(data_).(data_):
	pass

func _set_target(type_: String = "classic") -> void:
	match type_:
		"classic":
			var opponents = get_tree().get_nodes_in_group(_opponent)
			_target = opponents.front()
		"last beacon":
			_target = _beacon

