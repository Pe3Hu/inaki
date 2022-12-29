class_name Mob
extends Dancer


func _init(data_).(data_):
	pass

func _find_target_path() -> void:
	var opponents = get_tree().get_nodes_in_group(_opponent)
	_target = opponents.front()
